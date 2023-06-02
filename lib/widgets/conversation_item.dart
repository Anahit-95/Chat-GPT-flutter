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
            color: const Color.fromARGB(255, 81, 103, 230),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ConversationBloc(
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
              child: const Icon(
                Icons.highlight_remove,
                color: Colors.white,
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
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(conversation.type),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
