import 'package:chat_gpt_api/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/conversation_bloc/conversation_bloc.dart';
import '../blocks/conversations_bloc/conversation_list_bloc.dart';
import '../models/bot_model.dart';
import '../models/conversation_model.dart';
import '../screens/audio_conversation_screen.dart';
import '../screens/conversation_screen.dart';
import '../services/services.dart';

class ConversationItem extends StatelessWidget {
  final ConversationModel conversation;
  final Bot currentBot;
  const ConversationItem({
    super.key,
    required this.conversation,
    required this.currentBot,
  });

  @override
  Widget build(BuildContext context) {
    Widget screen;
    final conversationsBloc = BlocProvider.of<ConversationListBloc>(context);
    if (currentBot.title == 'Audio Reader' ||
        currentBot.title == 'Audio Translater') {
      screen = const AudioConversationScreen();
    } else {
      screen = const ConversationScreen();
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.indigo.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ConversationBloc(
                      dbHelper: DatabaseHelper(),
                      conversation: conversation,
                      systemMessage: currentBot.systemMessage,
                    ),
                    child: screen,
                  ),
                ),
              );
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            trailing: InkWell(
              onTap: () async {
                await Services.confirmActionDialog(
                  context: context,
                  title: 'Are you sure?',
                  content:
                      'Are you sure, you want to delete this conversation?',
                  onConfirm: () {
                    conversationsBloc.add(
                      DeleteConversation(id: conversation.id),
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Icon(
                Icons.highlight_remove,
                color: Theme.of(context).primaryColor.withOpacity(0.4),
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: currentBot.color,
              child: Icon(
                currentBot.iconData,
                color: Colors.white,
              ),
            ),
            title: Text(
              conversation.title,
              style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(conversation.type),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
