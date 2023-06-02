import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../blocks/image_bloc/image_bloc.dart';
import '../constants/constants.dart';
import '../services/services.dart';
import '../widgets/text_widget.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({super.key});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  String imageUrl = '';

  CroppedFile? _croppedFile;

  @override
  void initState() {
    imageUrl = context.read<ImageBloc>().imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    imageCache.clear();
    super.dispose();
  }

  Future<void> shareImage() async {
    try {
      if (_croppedFile == null) {
        CachedNetworkImageProvider imageProvider =
            CachedNetworkImageProvider(imageUrl);
        imageProvider.resolve(const ImageConfiguration());
        ImageStream imageStream =
            imageProvider.resolve(const ImageConfiguration());
        Completer<Uint8List> completer = Completer();
        imageStream.addListener(
            ImageStreamListener((imageInfo, synchronousCall) async {
          ByteData? byteData =
              await imageInfo.image.toByteData(format: ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();
          completer.complete(pngBytes);
        }));
        Uint8List pngBytes = await completer.future;

        final directory = await getTemporaryDirectory();
        const filename = 'shared_image.png';
        final file = await File('${directory.path}/$filename').create();
        await file.writeAsBytes(pngBytes);
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile], text: 'AI generated Image');
      } else {
        final xFile = XFile(_croppedFile!.path);
        await Share.shareXFiles([xFile], text: 'AI generated Image');
      }
    } catch (e) {
      log('Failed to take a screenshot');
      Services.errorSnackBar(
        context: context,
        errorMessage: 'Failed to take a screenshot.',
      );
    }
  }

  Future<void> _cropImage(path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.png,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Editor",
          toolbarColor: btnColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Editor",
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
    }
  }

  Future<void> _editImage() async {
    try {
      if (_croppedFile == null) {
        CachedNetworkImageProvider imageProvider =
            CachedNetworkImageProvider(imageUrl);
        imageProvider.resolve(const ImageConfiguration());
        ImageStream imageStream =
            imageProvider.resolve(const ImageConfiguration());
        Completer<Uint8List> completer = Completer();
        imageStream.addListener(
            ImageStreamListener((imageInfo, synchronousCall) async {
          ByteData? byteData =
              await imageInfo.image.toByteData(format: ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();
          completer.complete(pngBytes);
        }));
        Uint8List pngBytes = await completer.future;

        final directory = await getTemporaryDirectory();
        const filename = 'temp_image.png';
        final file = await File('${directory.path}/$filename').create();
        await file.writeAsBytes(pngBytes);
        await _cropImage(file.path);
      } else {
        await _cropImage(_croppedFile!.path);
      }
    } catch (e) {
      Services.errorSnackBar(
        context: context,
        errorMessage: 'Permission denied.',
      );
    }
  }

  // Download image function with getExternalStorageDirectory path

  Future<void> downloadImage() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      try {
        const foldername = 'AI Image';
        if (_croppedFile == null) {
          final directory = await getExternalStorageDirectory();
          final String appDocPath = directory!.path;
          final String folderPath = '$appDocPath/$foldername';
          final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
          if (!(await Directory(folderPath).exists())) {
            await Directory(folderPath).create(recursive: true);
          }
          final Completer<void> completer = Completer<void>();
          final imageProvider = CachedNetworkImageProvider(imageUrl);
          final imageStream =
              imageProvider.resolve(createLocalImageConfiguration(context));
          imageStream.addListener(ImageStreamListener((imageInfo, _) async {
            final ByteData? bytes =
                await imageInfo.image.toByteData(format: ImageByteFormat.png);
            final Uint8List pngBytes = bytes!.buffer.asUint8List();
            File savedFile = File('$folderPath/$filename');
            await savedFile.writeAsBytes(pngBytes);
            await GallerySaver.saveImage(savedFile.path, albumName: foldername);
            completer.complete();
          }));
          Future.delayed(Duration.zero, () {
            Services.confirmSnackBar(
              context: context,
              message: 'Downloaded to $folderPath',
            );
          });

          await completer.future;
        } else {
          await GallerySaver.saveImage(_croppedFile!.path,
              albumName: foldername);
          Future.delayed(Duration.zero, () {
            Services.confirmSnackBar(
              context: context,
              message: 'Downloaded to ${_croppedFile!.path}',
            );
          });
        }
      } catch (e) {
        Future.delayed(Duration.zero, () {
          Services.errorSnackBar(
            context: context,
            errorMessage: 'Failed to download.',
          );
        });
      }
    } else {
      Future.delayed(Duration.zero, () {
        Services.errorSnackBar(
          context: context,
          errorMessage: 'Permission denied.',
        );
      });
    }
  }

  // Download image function with hardcoded path "storage/emulated/0/$foldername"

  // Future<void> downloadImage(imageUrl) async {
  //   var result = await Permission.storage.request();
  //   if (result.isGranted) {
  //     try {
  //       const foldername = 'AI Image';
  //       final path = Directory("storage/emulated/0/$foldername");
  //
  //       final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
  //       if (!(await path.exists())) {
  //         path.createSync(recursive: true);
  //       }
  //
  //       final Completer<void> completer = Completer<void>();
  //       final image = CachedNetworkImageProvider(imageUrl);
  //       final imageStream =
  //           image.resolve(createLocalImageConfiguration(context));
  //       imageStream.addListener(ImageStreamListener((imageInfo, _) async {
  //         final ByteData? bytes =
  //             await imageInfo.image.toByteData(format: ImageByteFormat.png);
  //         final Uint8List pngBytes = bytes!.buffer.asUint8List();
  //         File savedFile = File('${path.path}/$filename');
  //         await savedFile.writeAsBytes(pngBytes);
  //
  //         await GallerySaver.saveImage(savedFile.path, albumName: foldername);
  //         completer.complete();
  //       }));
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Downloaded to $path',
  //           ),
  //         ),
  //       );
  //
  //       await completer.future;
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: TextWidget(
  //             label: 'Failed to download.',
  //           ),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: TextWidget(
  //           label: 'Permission denied',
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  //

  // shareImage and downloadImg functions with screenshot package

  //

  // Future<void> shareImage() async {
  //   await screenshotController
  //       .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
  //       .then((Uint8List? img) async {
  //     if (img != null) {
  //       final directory = (await getApplicationDocumentsDirectory()).path;
  //       const filename = "share.png";
  //       final imgPath = await File('$directory/$filename').create();
  //       await imgPath.writeAsBytes(img);
  //       final xFile = XFile(imgPath.path);
  //       await Share.shareXFiles([xFile], text: 'AI generated Image');
  //     } else {
  //       log('Failed to take a screenshot');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: TextWidget(
  //             label: 'Failed to take a screenshot.',
  //           ),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   });
  // }

  // Future<void> downloadImg() async {
  //   var result = await Permission.storage.request();
  //   if (result.isGranted) {
  //     const foldername = 'AI Image';
  //     final path = Directory("storage/emulated/0/$foldername");
  //
  //     final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
  //
  //     if (await path.exists()) {
  //       await screenshotController.captureAndSave(
  //         path.path,
  //         delay: const Duration(milliseconds: 100),
  //         fileName: filename,
  //         pixelRatio: 1.0,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Downloaded to ${path.path}',
  //           ),
  //         ),
  //       );
  //     } else {
  //       await path.create();
  //       await screenshotController.captureAndSave(
  //         path.path,
  //         delay: const Duration(milliseconds: 100),
  //         fileName: filename,
  //         pixelRatio: 1.0,
  //       );
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             'Downloaded to ${path.path}',
  //           ),
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: TextWidget(
  //           label: 'Permission denied',
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Widget _loadedImageLandscape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: _croppedFile == null
              ? Container(
                  constraints: const BoxConstraints(
                    // minHeight: MediaQuery.of(context).size.width * 0.7,
                    // minWidth: MediaQuery.of(context).size.height * 0.7,
                    minHeight: 256,
                    minWidth: 256,
                  ),
                  color: Colors.black54,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.4,
                      ),
                      child: Image.file(
                        File(_croppedFile!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.grey[500],
                          size: 30,
                        ),
                        onPressed: () {
                          _croppedFile = null;
                          setState(() {});
                          imageCache.clear();
                        },
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: btnColor),
              ),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.file_download_outlined,
                ),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: btnColor,
                ),
                onPressed: () async {
                  await downloadImage();
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: btnColor),
              ),
              child: IconButton(
                color: Colors.white,
                onPressed: () async {
                  await _editImage();
                },
                icon: const Icon(Icons.edit),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: btnColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: btnColor),
              ),
              child: IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.share,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: btnColor,
                ),
                onPressed: () async {
                  shareImage();
                  Services.confirmSnackBar(
                    context: context,
                    message: 'Image shared.',
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    // print('Image URL from bloc - ${imageBloc.imageUrl}');
    print('Image Url from page $imageUrl');
    return Expanded(
      flex: 3,
      child: BlocConsumer<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageError) {
            Services.errorSnackBar(
              context: context,
              errorMessage: state.message,
            );
          }
          if (state is ImageLoaded) {
            setState(() {
              imageUrl = state.imageUrl;
            });
          }
        },
        builder: (context, state) {
          if (state is ImageLoaded) {
            if (isLandscape) {
              return _loadedImageLandscape();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // child: Screenshot(
                  //   controller: screenshotController,
                  child: _croppedFile == null
                      ? Container(
                          color: Colors.black54,
                          constraints: const BoxConstraints(
                            minWidth: 256,
                            minHeight: 256,
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              child: Image.file(
                                File(_croppedFile!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_circle_left_outlined,
                                  color: Colors.grey[500],
                                  size: 30,
                                ),
                                onPressed: () {
                                  _croppedFile = null;
                                  setState(() {});
                                  imageCache.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                  // ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.download_for_offline_rounded,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                          backgroundColor: btnColor,
                        ),
                        onPressed: () async {
                          await downloadImage();
                        },
                        label: const Text('Download'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _editImage();
                      },
                      icon: const Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        backgroundColor: btnColor,
                      ),
                      label: const Text('Edit'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.share,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        backgroundColor: btnColor,
                      ),
                      onPressed: () async {
                        shareImage();
                        Services.confirmSnackBar(
                          context: context,
                          message: 'Image shared.',
                        );
                      },
                      label: const Text('Share'),
                    ),
                  ],
                )
              ],
            );
          }
          if (state is ImageLoading) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SpinKitSpinningLines(
                    color: btnColor,
                    size: 50,
                  ),
                  SizedBox(height: 12),
                  TextWidget(
                    label: "Waiting for image to be generated...",
                    fontSize: 16,
                  ),
                ],
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TextWidget(
                  label: "Your image will be displayed here.",
                  fontSize: 16.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
