import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/image_bloc/image_bloc.dart';
import '../services/services.dart';
import 'empty_image_container.dart';
import 'image_buttons.dart';
import 'loading_image_container.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({super.key});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  late ImageBloc imageBloc;
  // String imageUrl = '';

  // CroppedFile? _croppedFile;

  @override
  void initState() {
    imageBloc = BlocProvider.of<ImageBloc>(context);
    // imageBloc.add(SetImage());
    super.initState();
  }

  @override
  void dispose() {
    imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final isLandscape = mediaQuery.orientation == Orientation.landscape;
    print('Image URL from bloc - ${imageBloc.imageUrl}');
    print('Cropped image file path - ${imageBloc.croppedImageFile?.path}');
    // print('Image Url from page ${imageBloc}');
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
          if (state is ImageSuccess) {
            Services.confirmSnackBar(
              context: context,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          print(state.runtimeType);
          if (state is ImageEmpty) {
            return const EmptyImageContainer(
              message: 'Your image will be displayed here.',
            );
          }
          if (state is ImageError &&
              imageBloc.imageUrl.isEmpty &&
              imageBloc.croppedImageFile == null) {
            return const EmptyImageContainer(
              message: 'Something went wrong.',
            );
          }
          if (state is ImageLoading) {
            return const LoadingImageContainer();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageBloc.croppedImageFile == null
                    ? Container(
                        color: Colors.black54,
                        constraints: const BoxConstraints(
                          minWidth: 256,
                          minHeight: 256,
                        ),
                        child: Image.network(
                          imageBloc.imageUrl,
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
                              File(imageBloc.croppedImageFile!.path),
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
                                imageBloc.add(ReturnNetworkImage());
                              },
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              const ImageButtons(),
            ],
          );
        },
      ),
    );
  }
}


// Future<void> shareImage() async {
  //   try {
  //     if (_croppedFile == null) {
  //       CachedNetworkImageProvider imageProvider =
  //           CachedNetworkImageProvider(imageBloc.imageUrl);
  //       imageProvider.resolve(const ImageConfiguration());
  //       ImageStream imageStream =
  //           imageProvider.resolve(const ImageConfiguration());
  //       Completer<Uint8List> completer = Completer();
  //       imageStream.addListener(
  //           ImageStreamListener((imageInfo, synchronousCall) async {
  //         ByteData? byteData =
  //             await imageInfo.image.toByteData(format: ImageByteFormat.png);
  //         Uint8List pngBytes = byteData!.buffer.asUint8List();
  //         completer.complete(pngBytes);
  //       }));
  //       Uint8List pngBytes = await completer.future;

  //       final directory = await getTemporaryDirectory();
  //       const filename = 'shared_image.png';
  //       final file = await File('${directory.path}/$filename').create();
  //       await file.writeAsBytes(pngBytes);
  //       final xFile = XFile(file.path);
  //       await Share.shareXFiles([xFile], text: 'AI generated Image');
  //     } else {
  //       final xFile = XFile(_croppedFile!.path);
  //       await Share.shareXFiles([xFile], text: 'AI generated Image');
  //     }
  //   } catch (e) {
  //     log('Failed to take a screenshot');
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: 'Failed to take a screenshot.',
  //     );
  //   }
  // }

  // Future<void> _cropImage(path) async {
  //   final croppedFile = await ImageCropper().cropImage(
  //     sourcePath: path,
  //     compressQuality: 90,
  //     compressFormat: ImageCompressFormat.png,
  //     aspectRatioPresets: Platform.isAndroid
  //         ? [
  //             CropAspectRatioPreset.square,
  //             CropAspectRatioPreset.ratio3x2,
  //             CropAspectRatioPreset.original,
  //             CropAspectRatioPreset.ratio4x3,
  //             CropAspectRatioPreset.ratio16x9
  //           ]
  //         : [
  //             CropAspectRatioPreset.original,
  //             CropAspectRatioPreset.square,
  //             CropAspectRatioPreset.ratio3x2,
  //             CropAspectRatioPreset.ratio4x3,
  //             CropAspectRatioPreset.ratio5x3,
  //             CropAspectRatioPreset.ratio5x4,
  //             CropAspectRatioPreset.ratio7x5,
  //             CropAspectRatioPreset.ratio16x9
  //           ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: "Image Editor",
  //         toolbarColor: btnColor,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: false,
  //       ),
  //       IOSUiSettings(
  //         title: "Image Editor",
  //       ),
  //     ],
  //   );
  //   if (croppedFile != null) {
  //     setState(() {
  //       _croppedFile = croppedFile;
  //     });
  //   }
  // }

  // Future<void> _editImage() async {
  //   try {
  //     if (_croppedFile == null) {
  //       CachedNetworkImageProvider imageProvider =
  //           CachedNetworkImageProvider(imageBloc.imageUrl);
  //       imageProvider.resolve(const ImageConfiguration());
  //       ImageStream imageStream =
  //           imageProvider.resolve(const ImageConfiguration());
  //       Completer<Uint8List> completer = Completer();
  //       imageStream.addListener(
  //           ImageStreamListener((imageInfo, synchronousCall) async {
  //         ByteData? byteData =
  //             await imageInfo.image.toByteData(format: ImageByteFormat.png);
  //         Uint8List pngBytes = byteData!.buffer.asUint8List();
  //         completer.complete(pngBytes);
  //       }));
  //       Uint8List pngBytes = await completer.future;

  //       final directory = await getTemporaryDirectory();
  //       const filename = 'temp_image.png';
  //       final file = await File('${directory.path}/$filename').create();
  //       await file.writeAsBytes(pngBytes);
  //       await _cropImage(file.path);
  //     } else {
  //       await _cropImage(_croppedFile!.path);
  //     }
  //   } catch (e) {
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: 'Permission denied.',
  //     );
  //   }
  // }

  // Download image function with getExternalStorageDirectory path

  // Future<void> downloadImage() async {
  //   var result = await Permission.storage.request();
  //   if (result.isGranted) {
  //     try {
  //       const foldername = 'AI Image';
  //       if (_croppedFile == null) {
  //         final directory = await getTemporaryDirectory();
  //         final String appDocPath = directory.path;
  //         final String folderPath = '$appDocPath/$foldername';
  //         final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
  //         if (!(await Directory(folderPath).exists())) {
  //           await Directory(folderPath).create(recursive: true);
  //         }
  //         final Completer<void> completer = Completer<void>();
  //         final imageProvider = CachedNetworkImageProvider(imageBloc.imageUrl);
  //         final imageStream =
  //             imageProvider.resolve(createLocalImageConfiguration(context));
  //         imageStream.addListener(ImageStreamListener((imageInfo, _) async {
  //           final ByteData? bytes =
  //               await imageInfo.image.toByteData(format: ImageByteFormat.png);
  //           final Uint8List pngBytes = bytes!.buffer.asUint8List();
  //           File savedFile = File('$folderPath/$filename');
  //           await savedFile.writeAsBytes(pngBytes);
  //           await GallerySaver.saveImage(savedFile.path, albumName: foldername);
  //           completer.complete();
  //         }));
  //         Future.delayed(Duration.zero, () {
  //           Services.confirmSnackBar(
  //             context: context,
  //             message: 'Downloaded to $folderPath',
  //           );
  //         });

  //         await completer.future;
  //       } else {
  //         await GallerySaver.saveImage(_croppedFile!.path,
  //             albumName: foldername);
  //         Future.delayed(Duration.zero, () {
  //           Services.confirmSnackBar(
  //             context: context,
  //             message: 'Downloaded to ${_croppedFile!.path}',
  //           );
  //         });
  //       }
  //     } catch (e) {
  //       Future.delayed(Duration.zero, () {
  //         Services.errorSnackBar(
  //           context: context,
  //           errorMessage: 'Failed to download.',
  //         );
  //       });
  //     }
  //   } else {
  //     Future.delayed(Duration.zero, () {
  //       Services.errorSnackBar(
  //         context: context,
  //         errorMessage: 'Permission denied.',
  //       );
  //     });
  //   }
  // }

  // Widget _loadedImageLandscape() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         clipBehavior: Clip.antiAlias,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: _croppedFile == null
  //             ? Container(
  //                 constraints: const BoxConstraints(
  //                   minHeight: 256,
  //                   minWidth: 256,
  //                 ),
  //                 color: Colors.black54,
  //                 child: Image.network(
  //                   imageUrl,
  //                   fit: BoxFit.contain,
  //                 ),
  //               )
  //             : Stack(
  //                 children: [
  //                   Container(
  //                     constraints: BoxConstraints(
  //                       maxWidth: MediaQuery.of(context).size.width * 0.4,
  //                     ),
  //                     child: Image.file(
  //                       File(_croppedFile!.path),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   Positioned(
  //                     child: IconButton(
  //                       icon: Icon(
  //                         Icons.arrow_circle_left_outlined,
  //                         color: Colors.grey[500],
  //                         size: 30,
  //                       ),
  //                       onPressed: () {
  //                         _croppedFile = null;
  //                         setState(() {});
  //                         imageCache.clear();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //       ),
  //       const SizedBox(width: 20),
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Theme.of(context).primaryColor),
  //             ),
  //             child: IconButton(
  //               // color: Colors.white,
  //               color: Theme.of(context).primaryColor,
  //               icon: const Icon(
  //                 Icons.file_download_outlined,
  //               ),
  //               style: IconButton.styleFrom(
  //                 padding: const EdgeInsets.all(8),
  //                 backgroundColor: btnColor,
  //               ),
  //               onPressed: () async {
  //                 await downloadImage();
  //               },
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Theme.of(context).primaryColor),
  //             ),
  //             child: IconButton(
  //               // color: Colors.white,
  //               color: Theme.of(context).primaryColor,
  //               onPressed: () async {
  //                 await _editImage();
  //               },
  //               icon: const Icon(Icons.edit),
  //               style: ElevatedButton.styleFrom(
  //                 padding: const EdgeInsets.all(8),
  //                 backgroundColor: btnColor,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Theme.of(context).primaryColor),
  //             ),
  //             child: IconButton(
  //               // color: Colors.white,
  //               color: Theme.of(context).primaryColor,
  //               icon: const Icon(
  //                 Icons.share,
  //               ),
  //               style: ElevatedButton.styleFrom(
  //                 padding: const EdgeInsets.all(8),
  //                 backgroundColor: btnColor,
  //               ),
  //               onPressed: () async {
  //                 shareImage();
  //                 Services.confirmSnackBar(
  //                   context: context,
  //                   message: 'Image shared.',
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }
