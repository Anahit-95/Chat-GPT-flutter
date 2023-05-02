import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
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
  String image = '';
  bool isLoaded = false;

  ScreenshotController screenshotController = ScreenshotController();
  late TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> shareImage() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        const filename = "share.png";
        final imgPath = await File('$directory/$filename').create();
        await imgPath.writeAsBytes(img);

        final xFile = XFile(imgPath.path);
        await Share.shareXFiles([xFile], text: 'AI generated Image');
      } else {
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
    });
  }

  Future<void> downloadImg() async {
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
                              content: TextWidget(
                                label: 'Please pass the querry and size.',
                              ),
                              backgroundColor: Colors.red,
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
              flex: 3,
              child: isLoaded && image.isNotEmpty
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
                  : !isLoaded && textController.text.isNotEmpty
                      ? Container(
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
                              Text(
                                "Waiting for image to be generated...",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
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
                              SizedBox(height: 12),
                              Text(
                                "Your image will be displayed here.",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
