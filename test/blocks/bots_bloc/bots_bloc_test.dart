import 'package:bloc_test/bloc_test.dart';
import 'package:chat_gpt_api/blocks/bots_bloc/bots_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BotsBloc botsBloc;

  setUp(() {
    botsBloc = BotsBloc();
  });

  group('Bots Bloc Test', () {
    test('Cheking is initial state BotLoading', () {
      expect(botsBloc.state, BotsLoading());
    });

    blocTest<BotsBloc, BotsState>(
      'emits [BotLoading, BotLoaded] when FetchBots event is added',
      build: () => botsBloc,
      act: (bloc) => bloc.add(FetchBots()),
      expect: () => [
        BotsLoading(),
        BotsLoaded(botsBloc.botList),
      ],
    );
  });
}
