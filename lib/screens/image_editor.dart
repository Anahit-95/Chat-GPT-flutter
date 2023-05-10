// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class ImageEditor extends StatefulWidget {
//   final String imageUrl;

//   ImageEditor({required this.imageUrl});

//   @override
//   _ImageEditorState createState() => _ImageEditorState();
// }

// class _ImageEditorState extends State<ImageEditor> {
//   File? _imageFile;

//   // Method to display the image from the network
//   _displayImage() {
//     return Container(
//       child: CachedNetworkImage(
//         imageUrl: widget.imageUrl,
//         placeholder: (context, url) => CircularProgressIndicator(),
//         errorWidget: (context, url, error) => Icon(Icons.error),
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   // Method to create the cropped image file
//   Future<CroppedFile?> _cropImage(File imageFile) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: imageFile.path,
//       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: 100,
//       cropStyle: CropStyle.rectangle,
//       uiSettings: [AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         toolbarColor: Colors.blue,
//         toolbarWidgetColor: Colors.white,
//         cropFrameColor: Colors.blue,
//         statusBarColor: Colors.blue,
//         backgroundColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false,
//       ),
//       IOSUiSettings(
//         minimumAspectRatio: 1.0,
//       ),
//       ]
//     );
//     return croppedFile;
//   }

//   // Method to rotate the image
//   _rotateImage() async {
//     setState(() {
//       _imageFile = null;
//     });
//     CroppedFile? croppedFile = await _cropImage(_imageFile!);
//     File rotatedFile =
//         await FlutterExifRotation.rotateImage(path: croppedFile?.path);
//     setState(() {
//       _imageFile = rotatedFile;
//     });
//   }

//   // Method to scale the image
//   _scaleImage() async {
//     setState(() {
//       _imageFile = null;
//     });
//     File croppedFile = await _cropImage(_imageFile);
//     File scaledFile = await FlutterImageCompress.compressAndGetFile(
//         croppedFile.path, croppedFile.path,
//         minHeight: 1080, minWidth: 1080, quality: 60);
//     setState(() {
//       _imageFile = scaledFile;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _imageFile == null ? _displayImage() : Image.file(_imageFile),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () async {
//                     File croppedFile = await _cropImage(_imageFile);
//                     setState(() {
//                       _imageFile = croppedFile;
//                     });
//                   },
//                   child: Text('Crop'),
//                 ),
//                 TextButton(
//                   onPressed: _rotateImage,
//                   child: Text('Rotate'),
//                 ),
//                 TextButton(
//                   onPressed: _scaleImage,
//                   child: Text('Scale'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
