import 'package:chat_gpt_api/providers/chats_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/models_provider.dart';
import './constants/constants.dart';
import './screens/chat_screen.dart';
import './services/text_to_speach.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        // home: const ChatScreen(),
        home: HomePage(),
      ),
    );
  }
}
