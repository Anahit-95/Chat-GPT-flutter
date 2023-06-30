import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import '../services/services.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_list_widget.dart';
import '../widgets/send_audio_bar.dart';

class AudioToText extends StatefulWidget {
  const AudioToText({super.key});

  @override
  State<AudioToText> createState() => _AudioToTextState();
}

class _AudioToTextState extends State<AudioToText> {
  late TextToSpeechBloc textToSpeechBloc;
  late ScrollController _listScrollController;
  late ChatBloc chatBloc;

  @override
  void initState() {
    _listScrollController = ScrollController();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchChat());
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

  // Future<void> sendAudioFile({required ChatBloc chatBloc}) async {
  //   if (chatBloc.state is ChatWaiting) {
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: 'You cant send multiple messages at a time.',
  //     );
  //     return;
  //   }
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles();

  //     if (result != null) {
  //       chatBloc.add(AddUserMessage(msg: result.files.single.name));
  //       chatBloc.add(AddBotMessage(filePath: result.files.single.path!));
  //     }
  //   } catch (error) {
  //     log("error $error");
  //     Services.errorSnackBar(
  //       context: context,
  //       errorMessage: error.toString(),
  //     );
  //   } finally {
  //     if (mounted) {
  //       scrollListToEnd();
  //     }
  //   }
  // }

  void deleteMessage(int index) {
    chatBloc.add(DeleteMessage(
      msg: chatBloc.bot.chatList[index],
    ));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        title: chatBloc.bot.title,
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
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                SendAudioBar(
                  sendMessage: () async {
                    // await sendAudioFile(chatBloc: chatBloc);
                    chatBloc.add(SendAudioFile());
                    scrollListToEnd();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
