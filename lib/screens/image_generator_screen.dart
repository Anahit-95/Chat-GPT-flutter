import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/constants.dart';
import '../services/api_services.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  var sizes = ['Small', 'Medium', 'Large'];
  var values = ['256x256', '512x512', '1024x1024'];
  String? dropValue;
  var textController = TextEditingController();
  String image = '';
  var isLoaded = false;

  shareImage() async {
    await screenshotController
        .capture(delay: Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        final filename = "share.png";
        final imgPath = await File('${directory}/$filename').create();
        await imgPath.writeAsBytes(img);

        Share.shareFiles([imgPath.path], text: 'AI generated Image');
      } else {
        print('Failed to take a screenshot');
      }
    });
  }

  downloadImg() async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      const foldername = 'AI Image';
      final path = Directory("storage/emulated/0/$foldername");

      final filename = "${DateTime.now().millisecondsSinceEpoch}.png";

      if (await path.exists()) {
        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: filename,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Downloaded to ${path.path}',
            ),
          ),
        );
      } else {
        await path.create();
        await screenshotController.captureAndSave(
          path.path,
          delay: const Duration(milliseconds: 100),
          fileName: filename,
          pixelRatio: 1.0,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Downloaded to ${path.path}',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied',
          ),
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
        padding: const EdgeInsets.all(8.0),
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
                          height: 44,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "eg 'A monkey on moon' ",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
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
                        if (textController.text.isNotEmpty &&
                            dropValue!.isNotEmpty) {
                          setState(() {
                            isLoaded = false;
                          });
                          image = await ApiService.generateImage(
                            textController.text,
                            dropValue!,
                          );
                          setState(() {
                            isLoaded = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please pass the querry and size',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Generate'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: isLoaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Screenshot(
                            controller: screenshotController,
                            child: Image.network(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
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
                                  await downloadImg();
                                },
                                label: const Text('Download'),
                              ),
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
                                await shareImage();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
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
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(color: btnColor),
                          SizedBox(height: 12),
                          Text(
                            "Waiting for image to be generated...",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
