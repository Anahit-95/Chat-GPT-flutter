import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../services/assets_manager.dart';
import '../constants/constants.dart';
import './text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.msg,
    required this.chatIndex,
    required this.messageIndex,
    this.shouldAnimate = false,
  });

  final String msg;
  final int chatIndex;
  final int messageIndex;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    final textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : (shouldAnimate)
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(msg.trim()),
                                ],
                              ),
                            )
                          : SelectableText(
                              msg.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
                            builder: (context, state) {
                              if (state is TextToSpeechSpeaking &&
                                  messageIndex ==
                                      textToSpeechBloc.currentMessageIndex) {
                                return InkWell(
                                  onTap: () {
                                    textToSpeechBloc.add(StopSpeaking());
                                  },
                                  child: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                  ),
                                );
                              } else if (state is TextToSpeechSpeaking) {
                                return InkWell(
                                  onTap: () {
                                    textToSpeechBloc.add(StopSpeaking());
                                    textToSpeechBloc.add(StartSpeaking(
                                      text: msg,
                                      messageIndex: messageIndex,
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.volume_down_outlined,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    textToSpeechBloc.add(StartSpeaking(
                                      text: msg,
                                      messageIndex: messageIndex,
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.volume_down_outlined,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: msg));
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
