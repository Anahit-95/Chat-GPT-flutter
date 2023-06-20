import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MicButton extends StatelessWidget {
  final bool isListening;
  final Future<void> Function() micStopped;
  const MicButton({
    super.key,
    required this.isListening,
    required this.micStopped,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.white,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTap: () async {
            await micStopped();
          },
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                // color: bot.color.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ], borderRadius: BorderRadius.all(Radius.circular(50))),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.mic,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
