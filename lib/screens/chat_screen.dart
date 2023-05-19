import 'dart:developer';

import 'package:chat_gpt_api/blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../blocks/models_bloc/models_bloc.dart';
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
  // bool _isSpeaking = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late SpeechToText speechToText;

  late TextToSpeechBloc textToSpeechBloc;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    speechToText = SpeechToText();
    BlocProvider.of<ChatBloc>(context).add(FetchChat());
    textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    textToSpeechBloc.initializeTts();
    textToSpeechBloc.add(TtsInitialized());
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    speechToText.cancel();
    textToSpeechBloc.add(DisposeTts());
    super.dispose();
  }

  Future<void> sendMessageFCT(
      {required ModelsBloc modelsBloc, required ChatBloc chatBloc}) async {
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
        // chatProvider.addUserMessage(
        //   msg: msg,
        // );
        chatBloc.add(AddUserMessage(msg: msg));
        textEditingController.clear();
        focusNode.unfocus();
      });
      // await chatProvider.sendMessageAndGetAnswers(
      //   msg: msg,
      //   chosenModelId: modelsBloc.currentModel,
      // );

      final stateStream = BlocProvider.of<ChatBloc>(context).stream;

      chatBloc.add(SendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsBloc.currentModel,
      ));

      await stateStream.firstWhere((state) {
        return state is ChatLoaded && state.bot.chatList.length % 2 == 0;
      });

      setState(() {});

      Future.delayed(const Duration(milliseconds: 500), () {
        // speak(chatBloc.bot.chatList[chatBloc.bot.chatList.length - 1].msg);
        textToSpeechBloc.add(StartSpeaking(
          messageIndex: chatBloc.bot.chatList.length - 1,
          text: chatBloc.bot.chatList[chatBloc.bot.chatList.length - 1].msg,
        ));
      });
    } catch (error) {
      log("error $error");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: TextWidget(
      //       // label: error.toString(),
      //       label: chatProvider.errorMessage,
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    } finally {
      if (mounted) {
        setState(() {
          scrollListToEnd();
          _isTyping = false;
        });
      }
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
    // final modelsProvider = Provider.of<ModelsProvider>(context);
    final modelsBloc = BlocProvider.of<ModelsBloc>(context);
    // final chatProvider = Provider.of<ChatProvider>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(chatBloc.bot.title),
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
              // chatProvider.clearChat();
              chatBloc.add(ClearChat());
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget(
                  label: state.message,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                if (state is ChatLoading && chatBloc.bot.chatList.isEmpty) ...[
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 18,
                  ),
                ],
                Flexible(
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemCount: chatBloc.bot.chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatBloc.bot.chatList[index].msg,
                        chatIndex: chatBloc.bot.chatList[index].chatIndex,
                        messageIndex: index,
                        shouldAnimate:
                            chatBloc.bot.chatList.length - 1 == index,
                      );
                    },
                  ),
                ),
                if ((state is ChatWaiting) && _isTyping) ...[
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
                                modelsBloc: modelsBloc,
                                chatBloc: chatBloc,
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
                                  var available =
                                      await speechToText.initialize();
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
                                  modelsBloc: modelsBloc,
                                  chatBloc: chatBloc,
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
                ),
              ],
            ),
          );
        },
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
