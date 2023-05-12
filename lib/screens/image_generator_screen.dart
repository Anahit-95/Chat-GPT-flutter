import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/constants.dart';
import '../services/api_services.dart';
import '../widgets/text_widget.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  List<String> sizes = ['Small', 'Medium', 'Large'];
  List<String> values = ['256x256', '512x512', '1024x1024'];
  String? dropValue;
  String imageUrl =
      'https://images.unsplash.com/photo-1538360259192-2081a1f28ebb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHNhbiUyMGRpZWdvfGVufDB8fDB8fA%3D%3D&w=1000&q=80';
  bool isLoaded = false;

  CroppedFile? _croppedFile;

  // ScreenshotController screenshotController = ScreenshotController();
  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    imageCache.clear();
    super.dispose();
  }

  Future<void> getImageUrl() async {
    if (textController.text.isNotEmpty && dropValue!.isNotEmpty) {
      setState(() {
        isLoaded = true;
        _croppedFile = null;
      });
      imageCache.clear();
      try {
        imageUrl = await ApiService.generateImage(
          textController.text,
          dropValue!,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TextWidget(
              label: 'Failed to load image',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        isLoaded = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'Please pass the querry and size.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'Failed to take a screenshot.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // shareImage and downloadImg functions with screenshot package

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'Permission denied',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Downloaded to $folderPath',
              ),
            ),
          );
          await completer.future;
        } else {
          await GallerySaver.saveImage(_croppedFile!.path,
              albumName: foldername);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Downloaded to ${_croppedFile!.path}',
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TextWidget(
              label: 'Failed to download.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'Permission denied',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Image Generator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "Describe your image",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: const Icon(
                              Icons.expand_more,
                              color: btnColor,
                            ),
                            value: dropValue,
                            hint: const Text('Select size'),
                            items: List.generate(
                              sizes.length,
                              (index) => DropdownMenuItem(
                                value: values[index],
                                child: Text(sizes[index]),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropValue = value.toString();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        await getImageUrl();
                      },
                      child: const Text('Generate'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: !isLoaded && imageUrl.isNotEmpty
                  ? Column(
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
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.5),
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
                                            MediaQuery.of(context).size.height *
                                                0.5,
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Image shared'),
                                  ),
                                );
                              },
                              label: const Text('Share'),
                            ),
                          ],
                        )
                      ],
                    )
                  : !isLoaded && !imageUrl.isNotEmpty
                      ? Container(
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
                        )
                      : Container(
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
                        ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
