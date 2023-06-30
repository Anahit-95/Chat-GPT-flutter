import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../services/assets_manager.dart';
import '../constants/constants.dart';
import './selectable_text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.msg,
    required this.chatIndex,
    required this.messageIndex,
    this.shouldAnimate = false,
    this.stopAnimation,
  });

  final String msg;
  final int chatIndex;
  final int messageIndex;
  final bool shouldAnimate;
  final void Function()? stopAnimation;

  @override
  Widget build(BuildContext context) {
    final textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              chatIndex == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chatIndex == 1)
              Image.asset(
                AssetsManager.botImage,
                height: 30,
                width: 30,
              ),
            if (chatIndex == 1) const SizedBox(width: 4),
            IntrinsicWidth(
              stepWidth: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: chatIndex == 1
                      ? LinearGradient(
                          colors: [
                            btnColor.withOpacity(.8),
                            btnColor,
                            Colors.indigo
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: chatIndex == 0 ? Colors.grey[300] : null,
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(20),
                    topLeft: const Radius.circular(20),
                    bottomLeft: chatIndex == 0
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomRight: chatIndex == 1
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: chatIndex == 0
                          ? SelectableTextWidget(
                              label: msg,
                              color: Colors.black87,
                            )
                          : (shouldAnimate)
                              ? DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    repeatForever: false,
                                    displayFullTextOnTap: true,
                                    totalRepeatCount: 1,
                                    onFinished: stopAnimation,
                                    onTap: stopAnimation,
                                    animatedTexts: [
                                      TyperAnimatedText(msg.trim()),
                                    ],
                                  ),
                                )
                              : SelectableTextWidget(
                                  label: msg.trim(),
                                  fontWeight: FontWeight.w700,
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
                                          textToSpeechBloc
                                              .currentMessageIndex) {
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
                                        textToSpeechBloc.add(
                                          StartSpeaking(
                                            text: msg,
                                            messageIndex: messageIndex,
                                          ),
                                        );
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
            if (chatIndex == 0) const SizedBox(width: 4),
            if (chatIndex == 0)
              Image.asset(
                AssetsManager.userImage,
                height: 30,
                width: 30,
              ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
