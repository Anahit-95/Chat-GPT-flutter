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
    return AvatarGlow(
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
        child: CircleAvatar(
          radius: 35,
          backgroundColor: scaffoldBackgroundColor,
          child: const Icon(
            Icons.mic,
            color: Colors.deepOrange,
            size: 30,
          ),
        ),
      ),
    );
  }
}
