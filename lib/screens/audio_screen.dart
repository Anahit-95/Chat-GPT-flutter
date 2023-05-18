import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/chat_bloc/chat_bloc.dart';
import '../providers/chats_provider.dart';
import '../services/api_services.dart';
import '../services/assets_manager.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';
import '../constants/constants.dart';

class AudioToText extends StatefulWidget {
  const AudioToText({super.key});

  @override
  State<AudioToText> createState() => _AudioToTextState();
}

class _AudioToTextState extends State<AudioToText> {
  late ScrollController _listScrollController;
  bool _isTyping = false;

  @override
  void initState() {
    _listScrollController = ScrollController();
    BlocProvider.of<ChatBloc>(context).add(FetchChat());
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendAudioFile({required ChatBloc chatBloc}) async {
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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _isTyping = true;
          // chatProvider.addUserMessage(
          //   msg: result.files.single.name,
          // );
          chatBloc.add(AddUserMessage(msg: result.files.single.name));
        });
        if (chatBloc.bot.title == 'Audio Reader') {
          await ApiService.convertSpeechToText(result.files.single.path!)
              .then((value) {
            setState(() {
              // chatProvider.addBotMessage(
              //   msg: value,
              // );
              chatBloc.add(AddBotMessage(msg: value));
            });
          });
        } else {
          await ApiService.translateSpeechToEnglish(result.files.single.path!)
              .then((value) {
            setState(() {
              // chatProvider.addBotMessage(
              //   msg: value,
              // );
              chatBloc.add(AddBotMessage(msg: value));
            });
          });
        }
      }
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
        if (mounted) {
          scrollListToEnd();
          _isTyping = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final chatProvider = Provider.of<ChatProvider>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(chatBloc.bot.title),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo),
          ),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemCount: chatBloc.bot.chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatBloc.bot.chatList[index].msg,
                        chatIndex: chatBloc.bot.chatList[index].chatIndex,
                        shouldAnimate:
                            chatBloc.bot.chatList.length - 1 == index,
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
                Material(
                  color: cardColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            maxLines: 1,
                            'Choose Audio file to read from hgoiwhegihwoghioweihgohweo...',
                            style: TextStyle(
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scaffoldBackgroundColor,
                          ),
                          onPressed: () async {
                            await sendAudioFile(chatBloc: chatBloc);
                          },
                          child: const Text(
                            ' Pick File ',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
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
    );
  }
}
