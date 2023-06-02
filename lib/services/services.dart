import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/chat_model.dart';
import '../widgets/save_conversation_dialog.dart';
import '../widgets/text_widget.dart';
import '../widgets/drop_down.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: TextWidget(
                  label: 'Chosen Model:',
                  fontSize: 16,
                ),
              ),
              Flexible(
                flex: 2,
                child: ModelsDropDownWidget(),
              )
            ],
          ),
        );
      },
    );
  }

  static Future<void> saveConversationDialog(
      {required BuildContext context,
      required String type,
      required List<ChatModel> chatList}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SaveConversationDialog(
          type: type,
          chatList: chatList,
        );
      },
    );
  }

  static Future<void> confirmActionDialog({
    required BuildContext context,
    required String title,
    required String content,
    required void Function() onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: btnColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
              ),
              onPressed: onConfirm,
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  static void errorSnackBar(
      {required BuildContext context, required String errorMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          label: errorMessage,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void confirmSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          label: message,
        ),
      ),
    );
  }
}
