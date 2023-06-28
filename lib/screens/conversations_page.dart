import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import '../widgets/conversation_list.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ListTile(
                title: Text(
                  'My conversations',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  'Continue your conversations',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white54),
                ),
                trailing: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 30,
                  backgroundImage: AssetImage(AssetsManager.botPicture),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const ConversationList(),
      ],
    );
  }
}
