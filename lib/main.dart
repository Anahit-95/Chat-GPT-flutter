import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/models_bloc/models_bloc.dart';
import '../blocks/bots_bloc/bots_bloc.dart';
import '../blocks/conversations_bloc/conversation_list_bloc.dart';
import '../blocks/image_bloc/image_bloc.dart';
import '../blocks/text_to_speech_bloc/text_to_speech_bloc.dart';

import './services/db_services.dart';
import './screens/home_screen.dart';
import './constants/constants.dart';
import 'screens/home_page.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BotsBloc()..add(FetchBots()),
        ),
        BlocProvider(
          create: (_) => ConversationListBloc(dbHelper: DatabaseHelper())
            ..add(FetchConversations()),
        ),
        BlocProvider(create: (_) => ModelsBloc()),
        BlocProvider(create: (_) => ImageBloc()),
        BlocProvider(create: (_) => TextToSpeechBloc()),
      ],
      child: MaterialApp(
        title: 'GPT Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: btnColor,
          // scaffoldBackgroundColor: scaffoldBackgroundColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: btnColor,
          ),
        ),
        home: const HomePageDraft(),
      ),
    );
  }
}
