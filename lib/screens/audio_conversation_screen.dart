import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/conversation_bloc/conversation_bloc.dart';
import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../services/services.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/send_audio_bar.dart';

class AudioConversationScreen extends StatefulWidget {
  const AudioConversationScreen({super.key});

  @override
  State<AudioConversationScreen> createState() =>
      _AudioConversationScreenState();
}

class _AudioConversationScreenState extends State<AudioConversationScreen> {
  bool _shouldAnimate = false;

  late TextToSpeechBloc textToSpeechBloc;
  late ScrollController _listScrollController;
  late ConversationBloc conversationBloc;

  @override
  void initState() {
    _listScrollController = ScrollController();
    conversationBloc = BlocProvider.of<ConversationBloc>(context);
    conversationBloc.add(FetchConversation());
    textToSpeechBloc = BlocProvider.of<TextToSpeechBloc>(context);
    textToSpeechBloc.initializeTts();
    textToSpeechBloc.add(TtsInitialized());
    if (_listScrollController.hasClients) {
      scrollListToEnd();
    }
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textToSpeechBloc.add(DisposeTts());
    super.dispose();
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendAudioFile(
      {required ConversationBloc conversationBloc}) async {
    if (conversationBloc.state is ConversationWaiting) {
      Services.errorSnackBar(
        context: context,
        errorMessage: 'You cant send multiple messages at a time.',
      );
      return;
    }
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        conversationBloc.add(AddUserMessage(msg: result.files.single.name));
        conversationBloc
            .add(AddBotMessage(filePath: result.files.single.path!));
      }
    } catch (error) {
      log("error $error");
      Services.errorSnackBar(
        context: context,
        errorMessage: error.toString(),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        title: conversationBloc.conversation.title,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (state is ConversationLoading &&
                  conversationMessages.isEmpty) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
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
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(height: 15),
              SendAudioBar(
                sendMessage: () async {
                  await sendAudioFile(conversationBloc: conversationBloc);
                },
              ),
            ],
          ));
        },
      ),
    );
  }
}
