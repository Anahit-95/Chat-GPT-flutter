// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:chat_gpt_api/models/chat_model.dart';

import '../constants/constants.dart';
import '../models/bot_model.dart';
import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';
import '../services/text_to_speach.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  final Bot bot;
  final List<ChatModel> chatList;

  const ChatScreen({
    Key? key,
    required this.bot,
    required this.chatList,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool _isListening = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late SpeechToText speechToText;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    speechToText = SpeechToText();

    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    speechToText.cancel();
    super.dispose();
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
          chatList: widget.chatList,
        );
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
        systemMessage: widget.bot.systemMessage,
        chatList: widget.chatList,
      );
      setState(() {});

      Future.delayed(Duration(milliseconds: 500), () {
        TextToSpeech.speak(widget.chatList[widget.chatList.length - 1].msg);
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
    // var chatList = widget.bot.botType == ChatBotType.simpleBot
    //     ? chatProvider.getChatList
    //     : chatProvider.getSarcasticChatList;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.bot.title),
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
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: widget.chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: widget.chatList[index].msg,
                    chatIndex: widget.chatList[index].chatIndex,
                    shouldAnimate: widget.chatList.length - 1 == index,
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
              duration: Duration(milliseconds: 2000),
              glowColor: Colors.white,
              repeat: true,
              repeatPauseDuration: Duration(milliseconds: 100),
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
                  child: Icon(
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
