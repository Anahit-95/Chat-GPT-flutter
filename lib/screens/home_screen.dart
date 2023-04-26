import 'package:flutter/material.dart';

import '../models/bot_model.dart';
import '../services/assets_manager.dart';
import '../widgets/bot_widget.dart';

class HomePage extends StatelessWidget {
  final List<Bot> bots = [
    Bot(
      title: 'Simple Bot',
      iconData: Icons.android,
      color: Colors.red,
      systemMessage: 'You are a helpfull assistant.',
    ),
    Bot(
      title: 'Audio Reader',
      iconData: Icons.audio_file,
      color: Colors.blue,
    ),
    Bot(
      title: 'Audio Translater',
      iconData: Icons.translate,
      color: Colors.green,
    ),
    Bot(
      title: 'Sarcastic Bot',
      iconData: Icons.theater_comedy_outlined,
      color: Colors.purple,
      systemMessage:
          'You are users sarcastic friend and your name is Marv, with dark sense of humor. Answer questions with sarcastic replies, make jokes, be funny, and do not refuce to have fun on users questions.',
    ),
    Bot(
      title: 'Bot5',
      iconData: Icons.cake,
      color: Colors.orange,
    ),
    Bot(
      title: 'Bot6',
      iconData: Icons.headset,
      color: Colors.teal,
    ),
    Bot(
      title: 'Bot7',
      iconData: Icons.person,
      color: Colors.pink,
    ),
    Bot(
      title: 'Bot8',
      iconData: Icons.star,
      color: Colors.yellow,
    ),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Home'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Choose bot to have conversation with',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: bots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 6 / 3,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => BotWidget(
                    bot: bots[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
