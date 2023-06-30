import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/conversations_bloc/conversation_list_bloc.dart';
import '../constants/constants.dart';
import '../models/chat_model.dart';

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
    BlocProvider.of<ConversationListBloc>(context).add(CreateConversation(
      title: titleController.text,
      type: widget.type,
      chatList: widget.chatList,
    ));
    focusNode.unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter conversation title'),
      content: TextField(
          focusNode: focusNode,
          controller: titleController,
          decoration: InputDecoration(
            filled: false,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          cursorColor: Theme.of(context).primaryColor,
          onSubmitted: (value) async {
            await _saveConversation();
          }),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: btnColor),
          onPressed: () async {
            await _saveConversation();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
