import 'package:chat_gpt_api/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/constants.dart';

class LoadingImageContainer extends StatelessWidget {
  const LoadingImageContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cardColor.withOpacity(.2),
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
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
