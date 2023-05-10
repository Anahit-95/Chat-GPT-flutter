import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/assets_manager.dart';
import '../constants/constants.dart';
import '../services/text_to_speach.dart';
import './text_widget.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({
    super.key,
    required this.msg,
    required this.chatIndex,
    this.shouldAnimate = false,
    this.lastMessageSpeaking = false,
  });

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  bool lastMessageSpeaking;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool _isSpeaking = false;
  late TextToSpeech _textToSpeech;

  @override
  void initState() {
    super.initState();
    _textToSpeech = TextToSpeech(onStateChanged: (isSpeaking) {
      setState(() {
        _isSpeaking = isSpeaking;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      : (widget.shouldAnimate || widget.lastMessageSpeaking)
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
                          InkWell(
                            onTap: () {
                              if (_textToSpeech.isSpeaking ||
                                  widget.lastMessageSpeaking) {
                                print(widget.lastMessageSpeaking);
                                widget.lastMessageSpeaking = false;
                                _textToSpeech.stopSpeaking();
                              } else {
                                _textToSpeech.speak(widget.msg);
                              }
                            },
                            child: Icon(
                              _isSpeaking || widget.lastMessageSpeaking
                                  ? Icons.volume_up
                                  : Icons.volume_down_outlined,
                              color: Colors.white,
                            ),
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
