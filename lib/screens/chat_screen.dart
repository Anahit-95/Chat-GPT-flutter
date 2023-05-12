import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';
import '../services/text_to_speach.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';
import '../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool _isListening = false;
  bool _isSpeaking = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late SpeechToText speechToText;
  // late TextToSpeech _textToSpeech;
  late FlutterTts _textToSpeech;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    speechToText = SpeechToText();
    // _textToSpeech = TextToSpeech();
    _textToSpeech = FlutterTts();
    // _textToSpeech = TextToSpeech(onStateChanged: (isSpeaking) {
    //   if (mounted) {
    //     setState(() {
    //       _isSpeaking = isSpeaking;
    //     });
    //   }
    // });
    // TextToSpeech.initTTS();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    speechToText.cancel();
    _textToSpeech.stop();
    // if (_isSpeaking) {
    //   if (mounted) {
    //     _isSpeaking = false;
    //     _textToSpeech?.stopSpeaking();
    //   }
    // }
    super.dispose();
  }

  // Future<void> speak(String text) async {
  //   await _textToSpeech.speak(text);
  //   setState(() {
  //     _isSpeaking = true;
  //   });
  // }

  // Future<void> stopSpeaking() async {
  //   await _textToSpeech.stopSpeaking();
  //   setState(() {
  //     _isSpeaking = false;
  //   });
  // }

  Future<void> speak(String text) async {
    _textToSpeech.setStartHandler(() {
      print('TTS IS STARTED');
      setState(() {
        _isSpeaking = true;
      });
    });

    _textToSpeech.setCompletionHandler(() {
      print('Completed');
      setState(() {
        _isSpeaking = false;
      });
    });
    _textToSpeech.setErrorHandler((message) {
      setState(() {
        _isSpeaking = false;
      });
      print(message);
    });

    await _textToSpeech.awaitSpeakCompletion(true);
    _textToSpeech.speak(text);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'You cant send multiple messages at a time.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: 'Please type a message.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(
          msg: msg,
        );
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
        systemMessage: chatProvider.bot.systemMessage,
      );

      setState(() {});

      Future.delayed(const Duration(milliseconds: 500), () {
        speak(chatProvider
            .bot.chatList[chatProvider.bot.chatList.length - 1].msg);
      });
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(chatProvider.bot.title),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Image.asset(AssetsManager.openaiLogo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              chatProvider.clearChat();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.bot.chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.bot.chatList[index].msg,
                    chatIndex: chatProvider.bot.chatList[index].chatIndex,
                    shouldAnimate:
                        chatProvider.bot.chatList.length - 1 == index,
                    lastMessageSpeaking:
                        chatProvider.bot.chatList.length - 1 == index &&
                            _isSpeaking,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(height: 15),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: 'How can I help you?',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (!_isListening) {
                              var available = await speechToText.initialize();
                              if (available) {
                                setState(() {
                                  _isListening = true;
                                  speechToText.listen(
                                    onResult: (result) {
                                      setState(() {
                                        textEditingController.text =
                                            result.recognizedWords;
                                      });
                                    },
                                  );
                                });
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.mic,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider,
                            );
                          },
                          icon: const Icon(
                            Icons.send,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isListening
          ? AvatarGlow(
              endRadius: 75.0,
              animate: _isListening,
              duration: const Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              showTwoGlows: true,
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _isListening = false;
                  });
                  await speechToText.stop();
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
            )
          : null,
    );
  }
}
