import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/conversation_bloc/conversation_bloc.dart';
import '../blocks/models_bloc/models_bloc.dart';
import '../blocks/speech_to_text_bloc/speech_to_text_bloc.dart';
import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../services/services.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/mic_button.dart';
import '../widgets/send_message_bar.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late ConversationBloc conversationBloc;
  late TextToSpeechBloc textToSpeechBloc;
  late SpeechToTextBloc speechToTextBloc;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    conversationBloc = BlocProvider.of<ConversationBloc>(context);
    conversationBloc.add(FetchConversation());
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

  Future<void> sendMessageFCT({
    required ModelsBloc modelsBloc,
  }) async {
    conversationBloc.add(SendMessageGPT(
      msg: textEditingController.text,
      chosenModelId: modelsBloc.currentModel,
    ));
    textEditingController.clear();
    focusNode.unfocus();
    scrollListToEnd();
  }

  // Future<void> sendMessageFCT({
  //   required ModelsBloc modelsBloc,
  //   required ConversationBloc conversationBloc,
  // }) async {
  //   if (conversationBloc.state is ConversationWaiting) {
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
  //     conversationBloc.add(AddUserMessage(msg: msg));
  //     textEditingController.clear();
  //     focusNode.unfocus();

  //     final stateStream = BlocProvider.of<ConversationBloc>(context).stream;

  //     conversationBloc.add(SendMessageAndGetAnswers(
  //       msg: msg,
  //       chosenModelId: modelsBloc.currentModel,
  //     ));

  //     await stateStream.firstWhere((state) {
  //       return state is ConversationLoaded &&
  //           state.conversation.messages.last.chatIndex == 1;
  //     });

  //     var convMessages = conversationBloc.conversation.messages;

  //     Future.delayed(const Duration(milliseconds: 0), () {
  //       textToSpeechBloc.add(StartSpeaking(
  //         messageIndex: convMessages.length - 1,
  //         text: convMessages[convMessages.length - 1].msg,
  //       ));
  //     });
  //   } catch (error) {
  //     log("error $error");
  //   } finally {
  //     if (mounted) {
  //       scrollListToEnd();
  //     }
  //   }
  // }

  void deleteMessage(int index) {
    conversationBloc.add(DeleteMessage(
      msg: conversationBloc.conversation.messages[index],
    ));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final modelsBloc = BlocProvider.of<ModelsBloc>(context);

    return Scaffold(
      appBar: ChatAppBar(
        title: conversationBloc.conversation.title,
        showModels: true,
        // onSave: () async {
        //   conversationBloc.add(UpdateMessageList());
        //   await conversationBloc.stream.firstWhere((state) {
        //     return (state is ConversationLoaded);
        //   });
        //   Future.delayed(Duration.zero, () {
        //     Services.confirmSnackBar(
        //       context: context,
        //       message: 'Messages saved succesfully.',
        //     );
        //   });
        // },
        onClear: () => conversationBloc.add(ClearMessages()),
      ),
      body: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (context, state) {
          if (state is ConversationError) {
            Services.errorSnackBar(
              context: context,
              errorMessage: state.message,
            );
          }
          if (state is ConversationLoaded) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => scrollListToEnd(),
            );
          }
        },
        builder: (context, state) {
          var conversationMessages = conversationBloc.conversation.messages;
          return SafeArea(
            child: Column(
              children: [
                if (state is ConversationLoading &&
                    conversationMessages.isEmpty) ...[
                  SpinKitThreeBounce(
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ],
                ChatListWidget(
                  chatList: conversationMessages,
                  listScrollController: _listScrollController,
                  shouldAnimate: conversationBloc.shouldAnimate,
                  stopAnimation: () => conversationBloc.add(StopAnimating()),
                  deleteMessage: deleteMessage,
                ),
                if (state is ConversationWaiting) ...[
                  SpinKitThreeBounce(
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ],
                SendMessageBar(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  sendMessage: () => sendMessageFCT(
                    modelsBloc: modelsBloc,
                    // conversationBloc: conversationBloc,
                  ),
                )
              ],
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
