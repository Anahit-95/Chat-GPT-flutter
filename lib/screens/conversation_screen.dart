import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../blocks/conversation_bloc/conversation_bloc.dart';
import '../blocks/models_bloc/models_bloc.dart';
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
  bool _isListening = false;
  bool _shouldAnimate = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late SpeechToText speechToText;
  late ConversationBloc conversationBloc;
  late TextToSpeechBloc textToSpeechBloc;

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    speechToText = SpeechToText();
    conversationBloc = BlocProvider.of<ConversationBloc>(context);
    conversationBloc.add(FetchConversation());
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
    required ConversationBloc conversationBloc,
  }) async {
    if (conversationBloc.state is ConversationWaiting) {
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
      conversationBloc.add(AddUserMessage(msg: msg));
      textEditingController.clear();
      focusNode.unfocus();

      final stateStream = BlocProvider.of<ConversationBloc>(context).stream;

      conversationBloc.add(SendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsBloc.currentModel,
      ));

      await stateStream.firstWhere((state) {
        return state is ConversationLoaded &&
            state.conversation.messages.last.chatIndex == 1;
      });

      var convMessages = conversationBloc.conversation.messages;

      Future.delayed(const Duration(milliseconds: 0), () {
        textToSpeechBloc.add(StartSpeaking(
          messageIndex: convMessages.length - 1,
          text: convMessages[convMessages.length - 1].msg,
        ));
      });
    } catch (error) {
      log("error $error");
    } finally {
      if (mounted) {
        scrollListToEnd();
      }
    }
  }

  void deleteMessage(int index) {
    conversationBloc.add(DeleteMessage(
      msg: conversationBloc.conversation.messages[index],
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
        title: conversationBloc.conversation.title,
        showModels: true,
        onSave: () async {
          conversationBloc.add(UpdateMessageList());
          await conversationBloc.stream.firstWhere((state) {
            return (state is ConversationLoaded);
          });
          Future.delayed(Duration.zero, () {
            Services.confirmSnackBar(
              context: context,
              message: 'Messages saved succesfully.',
            );
          });
        },
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
          if (state is ConversationAnimating) {
            _shouldAnimate = true;
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
                  shouldAnimate: _shouldAnimate,
                  deleteMessage: deleteMessage,
                ),
                if (state is ConversationWaiting) ...[
                  SpinKitThreeBounce(
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ],
                // const SizedBox(height: 15),
                SendMessageBar(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  micListening: micListening,
                  sendMessage: () => sendMessageFCT(
                    modelsBloc: modelsBloc,
                    conversationBloc: conversationBloc,
                  ),
                )
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
