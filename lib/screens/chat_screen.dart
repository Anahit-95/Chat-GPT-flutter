import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../blocks/speech_to_text_bloc/speech_to_text_bloc.dart';
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
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late ChatBloc chatBloc;
  late TextToSpeechBloc textToSpeechBloc;
  late SpeechToTextBloc speechToTextBloc;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchChat());
    textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    textToSpeechBloc.initializeTts();
    textToSpeechBloc.add(TtsInitialized());
    speechToTextBloc = BlocProvider.of<SpeechToTextBloc>(context);
    if (_listScrollController.hasClients) {
      scrollListToEnd();
    }
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    textToSpeechBloc.add(DisposeTts());
    speechToTextBloc.add(StopListening());
    super.dispose();
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  // Future<void> sendMessageFCT({
  //   required ModelsBloc modelsBloc,
  //   required ChatBloc chatBloc,
  // }) async {
  //   if (chatBloc.state is ChatWaiting) {
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: 'You cant send multiple messages at a time.',
  //     );
  //     return;
  //   }
  //   if (textEditingController.text.isEmpty) {
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: 'Please type a message.',
  //     );
  //     return;
  //   }
  //   try {
  //     String msg = textEditingController.text;
  //     chatBloc.add(AddUserMessage(msg: msg));
  //     textEditingController.clear();
  //     focusNode.unfocus();

  //     final stateStream = BlocProvider.of<ChatBloc>(context).stream;

  //     chatBloc.add(SendMessageAndGetAnswers(
  //       msg: msg,
  //       chosenModelId: modelsBloc.currentModel,
  //     ));

  //     await stateStream.firstWhere((state) {
  //       return state is ChatLoaded && state.bot.chatList.last.chatIndex == 1;
  //     });

  //     var chatMessages = chatBloc.bot.chatList;

  //     Future.delayed(const Duration(milliseconds: 0), () {
  //       textToSpeechBloc.add(StartSpeaking(
  //         messageIndex: chatMessages.length - 1,
  //         text: chatMessages[chatMessages.length - 1].msg,
  //       ));
  //     });
  //   } catch (error) {
  //     log("error $error");
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: '$error',
  //     );
  //   } finally {
  //     if (mounted) {
  //       scrollListToEnd();
  //     }
  //   }
  // }

  Future<void> sendMessageFCT({
    required ModelsBloc modelsBloc,
  }) async {
    chatBloc.add(SendMessageGPT(
      msg: textEditingController.text,
      chosenModelId: modelsBloc.currentModel,
    ));
    textEditingController.clear();
    focusNode.unfocus();
    scrollListToEnd();
  }

  void deleteMessage(int index) {
    chatBloc.add(DeleteMessage(
      msg: chatBloc.bot.chatList[index],
    ));
    Navigator.of(context).pop(true);
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
          if (state is ChatLoaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => scrollListToEnd(),
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              if (focusNode.hasFocus) {
                focusNode.unfocus();
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  if (state is ChatLoading &&
                      chatBloc.bot.chatList.isEmpty) ...[
                    SpinKitThreeBounce(
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ],
                  ChatListWidget(
                    chatList: chatBloc.bot.chatList,
                    listScrollController: _listScrollController,
                    shouldAnimate: chatBloc.shouldAnimate,
                    stopAnimation: () => chatBloc.add(StopAnimating()),
                    deleteMessage: deleteMessage,
                  ),
                  if (state is ChatWaiting) ...[
                    SpinKitThreeBounce(
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ],
                  const SizedBox(height: 15),
                  SendMessageBar(
                    textEditingController: textEditingController,
                    focusNode: focusNode,
                    sendMessage: () => sendMessageFCT(
                      modelsBloc: modelsBloc,
                      // chatBloc: chatBloc,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocConsumer<SpeechToTextBloc, SpeechToTextState>(
        listener: (context, state) {
          print(state.runtimeType);
          if (state is ListeningStarted) {
            textEditingController.text = state.recognizedWords;
          }
          if (state is SpeechToTextError) {
            Services.errorSnackBar(
              context: context,
              errorMessage: state.error,
            );
          }
        },
        builder: (context, state) {
          if (state is ListeningStarted) {
            return const MicButton();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
