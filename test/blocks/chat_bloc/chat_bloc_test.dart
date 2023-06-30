import 'package:bloc_test/bloc_test.dart';
import 'package:chat_gpt_api/blocks/chat_bloc/chat_bloc.dart';
import 'package:chat_gpt_api/blocks/text_to_speech_bloc/text_to_speech_bloc.dart';
import 'package:chat_gpt_api/models/bot_model.dart';
import 'package:chat_gpt_api/models/chat_model.dart';
import 'package:chat_gpt_api/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class MockTextToSpeechBloc extends Mock implements TextToSpeechBloc {}

void main() {
  late ChatBloc chatBloc;
  late Bot bot;
  // late MockApiService mockApiService;

  setUp(() {
    // mockApiService = MockApiService();
    bot = Bot(
      title: 'Simple Bot',
      iconData: Icons.android,
      color: Colors.red,
      systemMessage: 'You are a helpfull assistant.',
      // ignore: prefer_const_literals_to_create_immutables
      chatList: [
        const ChatModel(msg: 'Hi', chatIndex: 0),
        const ChatModel(msg: 'Hello', chatIndex: 1),
      ],
    );
    chatBloc = ChatBloc(bot: bot, textToSpeechBloc: MockTextToSpeechBloc());
  });

  group('ChatBloc testing', () {
    test('Checking initial state for chatBloc is ChatLoading', () {
      expect(chatBloc.state, ChatLoading());
    });

    blocTest<ChatBloc, ChatState>(
      '''emits ChatLoaded with initial chat list 
      when FetchChat event is called''',
      build: () => chatBloc,
      wait: const Duration(seconds: 1),
      act: (bloc) => bloc.add(FetchChat()),
      expect: () => [
        ChatLoading(),
        ChatLoaded(bot: bot),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '''emits ChatLoaded with appended message 
      when AddUserMessage event is called''',
      build: () => chatBloc,
      act: (bloc) {
        bloc.add(FetchChat());
        bloc.add(const AddUserMessage(msg: 'How are you?'));
      },
      expect: () => [
        ChatLoading(),
        ChatLoaded(
          bot: bot.copyWith(
            chatList: [
              const ChatModel(msg: 'Hi', chatIndex: 0),
              const ChatModel(msg: 'Hello', chatIndex: 1),
              const ChatModel(msg: 'How are you?', chatIndex: 0),
            ],
          ),
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      '''emits ChatLoaded with empty chatList 
      when ClearChat event is called''',
      build: () => chatBloc,
      act: (bloc) {
        bloc.add(FetchChat());
        bloc.add(ClearChat());
      },
      expect: () => [
        ChatLoading(),
        ChatLoaded(bot: bot.copyWith(chatList: [])),
        ChatWaiting(),
      ],
    );

    blocTest(
      '''emits [ChatWaiting, ChatLoaded] with 
    removing given ChatModel from chatlist''',
      build: () => chatBloc,
      act: (bloc) {
        bloc.add(FetchChat());
        bloc.add(
          const DeleteMessage(
            msg: ChatModel(msg: 'Hello', chatIndex: 1),
          ),
        );
      },
      expect: () => [
        ChatLoading(),
        ChatWaiting(),
        ChatLoaded(
          bot: bot.copyWith(
            chatList: [const ChatModel(msg: 'Hi', chatIndex: 0)],
          ),
        ),
      ],
    );
  });
}
