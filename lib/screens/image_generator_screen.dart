import 'package:flutter/material.dart';

import '../widgets/image_container.dart';
import '../widgets/image_generate_widget.dart';

class ImageGeneratorScreen extends StatelessWidget {
  const ImageGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

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
        child: isLandscape
            ? Row(
                children: const [
                  ImageGenerateWidget(),
                  SizedBox(width: 15),
                  ImageContainer(),
                ],
              )
            : Column(
                children: const [
                  ImageGenerateWidget(),
                  ImageContainer(),
                  SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
