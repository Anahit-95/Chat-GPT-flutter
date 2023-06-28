import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../blocks/speech_to_text_bloc/speech_to_text_bloc.dart';

class MicButton extends StatelessWidget {
  const MicButton({super.key});

  @override
  Widget build(BuildContext context) {
    final speechToTextBloc = BlocProvider.of<SpeechToTextBloc>(context);
    return Center(
      child: AvatarGlow(
        endRadius: 75.0,
        animate: speechToTextBloc.state.isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: Theme.of(context).primaryColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTap: () => speechToTextBloc.add(StopListening()),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
