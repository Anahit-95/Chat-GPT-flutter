import 'package:flutter/material.dart';

import 'package:chat_gpt_api/widgets/text_widget.dart';

import '../constants/constants.dart';

class EmptyImageContainer extends StatelessWidget {
  final String message;
  const EmptyImageContainer({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cardColor.withOpacity(.2),
        border: Border.all(
          color: Colors.black.withOpacity(.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            label: message,
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
