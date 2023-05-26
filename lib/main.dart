import 'package:chat_gpt_api/blocks/conversations_bloc/conversation_list_bloc.dart';
import 'package:chat_gpt_api/blocks/image_bloc/image_bloc.dart';
import 'package:chat_gpt_api/blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import './providers/bots_provider.dart';
import './providers/chats_provider.dart';
import './providers/models_provider.dart';
import './constants/constants.dart';
import './services/text_to_speach.dart';
import './screens/home_screen.dart';
import 'blocks/bots_bloc/bots_bloc.dart';
import 'blocks/models_bloc/models_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TextToSpeech.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BotsBloc()..add(FetchBots())),
        BlocProvider(
            create: (_) => ConversationListBloc()..add(FetchConversations())),
        BlocProvider(create: (_) => ModelsBloc()),
        BlocProvider(create: (_) => ImageBloc()),
        BlocProvider(create: (_) => TextToSpeechBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
