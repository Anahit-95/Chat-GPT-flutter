import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_api/blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/assets_manager.dart';
import '../constants/constants.dart';
// import '../services/text_to_speach.dart';
import './text_widget.dart';

class ChatWidget extends StatefulWidget {
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
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late TextToSpeechBloc textToSpeechBloc;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: widget.chatIndex == 0
                      ? TextWidget(
                          label: widget.msg,
                        )
                      : (widget.shouldAnimate)
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
                                  TyperAnimatedText(widget.msg.trim()),
                                ],
                              ),
                            )
                          : Text(
                              widget.msg.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                ),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocConsumer<TextToSpeechBloc, TextToSpeechState>(
                            listener: (context, state) {
                              if (state is TextToSpeechMuted) {
                                setState(() {
                                  _isSpeaking = false;
                                });
                              }
                              if (state is TextToSpeechSpeaking) {
                                setState(() {
                                  _isSpeaking = true;
                                });
                              }
                            },
                            builder: (context, state) {
                              if (state is TextToSpeechSpeaking &&
                                  widget.messageIndex ==
                                      textToSpeechBloc.currentMessageIndex) {
                                return InkWell(
                                  onTap: () {
                                    // widget.lastMessageSpeaking = false;
                                    textToSpeechBloc.add(StopSpeaking());
                                  },
                                  child: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  textToSpeechBloc.add(StartSpeaking(
                                    text: widget.msg,
                                    messageIndex: widget.messageIndex,
                                  ));
                                },
                                child: const Icon(
                                  Icons.volume_down_outlined,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: widget.msg));
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
        )
      ],
    );
  }
}
