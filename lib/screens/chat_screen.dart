import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../blocks/models_bloc/models_bloc.dart';
import '../services/services.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/mic_button.dart';
import '../widgets/send_message_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isListening = false;
  bool _shouldAnimate = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late SpeechToText speechToText;
  late ChatBloc chatBloc;
  late TextToSpeechBloc textToSpeechBloc;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    speechToText = SpeechToText();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchChat());
    textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    textToSpeechBloc.initializeTts();
    textToSpeechBloc.add(TtsInitialized());
    if (_listScrollController.hasClients) {
      scrollListToEnd();
    }
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

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsBloc modelsBloc,
    required ChatBloc chatBloc,
  }) async {
    if (chatBloc.state is ChatWaiting) {
      Services.errorSnackBar(
        context: context,
        errorMessage: 'You cant send multiple messages at a time.',
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      Services.errorSnackBar(
        context: context,
        errorMessage: 'Please type a message.',
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      chatBloc.add(AddUserMessage(msg: msg));
      textEditingController.clear();
      focusNode.unfocus();

      final stateStream = BlocProvider.of<ChatBloc>(context).stream;

      chatBloc.add(SendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsBloc.currentModel,
      ));

      await stateStream.firstWhere((state) {
        return state is ChatLoaded && state.bot.chatList.last.chatIndex == 1;
      });

      var chatMessages = chatBloc.bot.chatList;

      Future.delayed(const Duration(milliseconds: 0), () {
        textToSpeechBloc.add(StartSpeaking(
          messageIndex: chatMessages.length - 1,
          text: chatMessages[chatMessages.length - 1].msg,
        ));
      });
    } catch (error) {
      log("error $error");
      Services.errorSnackBar(
        context: context,
        errorMessage: '$error',
      );
    } finally {
      if (mounted) {
        scrollListToEnd();
      }
    }
  }

  void deleteMessage(int index) {
    chatBloc.add(DeleteMessage(
      msg: chatBloc.bot.chatList[index],
    ));
    Navigator.of(context).pop(true);
  }

  Future<void> micListening() async {
    if (!_isListening) {
      var available = await speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          speechToText.listen(
            onResult: (result) {
              setState(() {
                textEditingController.text = result.recognizedWords;
              });
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final modelsBloc = BlocProvider.of<ModelsBloc>(context);

    return Scaffold(
      appBar: ChatAppBar(
        title: chatBloc.bot.title,
        showModels: true,
        onSave: () async {
          await Services.saveConversationDialog(
            context: context,
            type: chatBloc.bot.title,
            chatList: chatBloc.bot.chatList,
          );
        },
        onClear: () => chatBloc.add(ClearChat()),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            Services.errorSnackBar(
              context: context,
              errorMessage: state.message,
            );
          }
          if (state is ChatAnimating) {
            _shouldAnimate = true;
          }
          if (state is ChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => scrollListToEnd(),
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
                ChatListWidget(
                  chatList: chatBloc.bot.chatList,
                  listScrollController: _listScrollController,
                  shouldAnimate: _shouldAnimate,
                  deleteMessage: deleteMessage,
                ),
                if (state is ChatWaiting) ...[
                  const SpinKitThreeBounce(
                    color: Colors.white,
                    size: 18,
                  ),
                ],
                const SizedBox(height: 15),
                SendMessageBar(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  micListening: micListening,
                  sendMessage: () => sendMessageFCT(
                    modelsBloc: modelsBloc,
                    chatBloc: chatBloc,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isListening
          ? MicButton(
              isListening: _isListening,
              micStopped: () async {
                setState(() {
                  _isListening = false;
                });
                await speechToText.stop();
              },
            )
          : null,
    );
  }
}
