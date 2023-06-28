import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import '../widgets/bot_list.dart';

class BotPage extends StatelessWidget {
  const BotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ListTile(
                title: Text(
                  'Hi Friend!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  'Choose bot to have conversation',
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
        const BotList(),
        const SizedBox(height: 16),
      ],
    );
  }
}
