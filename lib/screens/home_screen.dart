import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import '../widgets/bot_list.dart';
import '../widgets/conversation_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Home'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: const [
              Text(
                'Choose bot to have conversation with',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              BotList(),
              SizedBox(height: 16),
              Text(
                'My Conversations',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ConversationList(),
            ],
          ),
        ),
      ),
    );
  }
}
