import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/conversations_bloc/conversation_list_bloc.dart';
import '../constants/constants.dart';
import '../models/chat_model.dart';
import '../services/services.dart';

class SaveConversationDialog extends StatefulWidget {
  final String type;
  final List<ChatModel> chatList;

  const SaveConversationDialog({
    Key? key,
    required this.type,
    required this.chatList,
  }) : super(key: key);

  @override
  State<SaveConversationDialog> createState() => _SaveConversationDialogState();
}

class _SaveConversationDialogState extends State<SaveConversationDialog> {
  late TextEditingController titleController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    titleController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveConversation() async {
    if (titleController.text.isEmpty) {
      Services.errorSnackBar(
        context: context,
        errorMessage: "Please enter conversation's title.",
      );
      return;
    }

    Navigator.of(context).pop();
    BlocProvider.of<ConversationListBloc>(context).add(CreateConversation(
      title: titleController.text,
      type: widget.type,
      chatList: widget.chatList,
    ));
    focusNode.unfocus();
    Services.confirmSnackBar(
      context: context,
      message: "Conversation created succesfully.",
    );
    print('worked from function');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter conversation title'),
      content: TextField(
          focusNode: focusNode,
          controller: titleController,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: btnColor,
              ),
            ),
          ),
          cursorColor: btnColor,
          onSubmitted: (value) async {
            await _saveConversation();
          }),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: btnColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        BlocListener<ConversationListBloc, ConversationListState>(
          // Actions written from listener are not working
          listener: (context, state) {
            if (state is ConversationListLoaded) {
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pushNamed('/');
                Services.confirmSnackBar(
                  context: context,
                  message: "Conversation created succesfully.",
                );
                print('worked from Bloc listener');
              });
            }
            if (state is ConversationListError) {
              Future.delayed(Duration.zero, () {
                Services.errorSnackBar(
                  context: context,
                  errorMessage: state.message,
                );
              });
            }
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: btnColor),
            onPressed: () async {
              await _saveConversation();
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }
}
