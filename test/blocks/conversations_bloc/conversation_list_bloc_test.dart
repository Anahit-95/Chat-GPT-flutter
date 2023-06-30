import 'package:bloc_test/bloc_test.dart';
import 'package:chat_gpt_api/blocks/conversations_bloc/conversation_list_bloc.dart';
import 'package:chat_gpt_api/models/chat_model.dart';
import 'package:chat_gpt_api/models/conversation_model.dart';
import 'package:chat_gpt_api/services/db_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late ConversationListBloc conversationListBloc;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    conversationListBloc = ConversationListBloc(dbHelper: mockDatabaseHelper);
  });

  group('ConversationListBloc Test', () {
    List<ConversationModel> fetchedConversations = [
      ConversationModel(
        id: 1,
        title: 'Title 1',
        type: 'Simple Bot',
        messages: const <ChatModel>[],
      ),
      ConversationModel(
        id: 2,
        title: 'Title 2',
        type: 'Simple Bot',
        messages: const <ChatModel>[],
      ),
      ConversationModel(
        id: 3,
        title: 'Title 3',
        type: 'Simple Bot',
        messages: const <ChatModel>[],
      ),
    ];

    Future<void> getConversationListFromDB() async {
      when(() => mockDatabaseHelper.getConversationList()).thenAnswer(
        (_) async => fetchedConversations,
      );
    }

    test('Cheking is initial state ConversationListLoading', () {
      expect(conversationListBloc.state, ConversationListLoading());
    });

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListLoaded] 
      when FetchConversations event is added''',
      build: () {
        getConversationListFromDB();
        return conversationListBloc;
      },
      act: (bloc) => bloc.add(FetchConversations()),
      expect: () => [
        ConversationListLoading(),
        ConversationListLoaded(
          conversations: fetchedConversations.reversed.toList(),
        ),
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListError] 
      when FetchConversations event throws error''',
      build: () {
        when(() => mockDatabaseHelper.getConversationList())
            .thenThrow('Error from Database.');
        return conversationListBloc;
      },
      act: (bloc) => bloc.add(FetchConversations()),
      expect: () => [
        ConversationListLoading(),
        const ConversationListError(
          'Failed to load conversations: Error from Database.',
        ),
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListLoaded] 
      when CreateConversation event is added''',
      build: () => conversationListBloc,
      act: (bloc) => bloc.add(
        const CreateConversation(
          title: 'Title 1',
          type: 'Simple Bot',
          chatList: <ChatModel>[
            ChatModel(msg: 'Hi', chatIndex: 0),
            ChatModel(msg: 'Hi, how can I assist you?', chatIndex: 1),
          ],
        ),
      ),
      expect: () => [
        ConversationListLoading(),
        ConversationCreated(),
        ConversationListLoaded(
          conversations: [
            ConversationModel(
              id: 1,
              title: 'Title 1',
              type: 'Simple Bot',
              messages: const [],
            ),
          ],
        ),
      ],
      setUp: () {
        when(() => mockDatabaseHelper.createConversation(any(), any()))
            .thenAnswer((_) => Future.value(1));
        when(() => mockDatabaseHelper.createMessageList(any(), any()))
            .thenAnswer((_) => Future.value());
      },
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListerror] 
      when CreateConversation event failed 
      because of createConversation function from database''',
      build: () => conversationListBloc,
      setUp: () {
        when(() => mockDatabaseHelper.createConversation(any(), any()))
            .thenThrow('Failed to store data in conversations table.');
      },
      act: (bloc) => bloc.add(const CreateConversation(
        title: 'Title 1',
        type: 'Simple Bot',
        chatList: <ChatModel>[],
      )),
      expect: () => [
        ConversationListLoading(),
        const ConversationListError(
          'Something went wrong: Failed to store data in conversations table.',
        )
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListerror] 
      when CreateConversation event failed 
      because of createMessageList function from database''',
      build: () => conversationListBloc,
      setUp: () {
        when(() => mockDatabaseHelper.createConversation(any(), any()))
            .thenAnswer((_) => Future.value(1));
        when(() => mockDatabaseHelper.createMessageList(any(), any()))
            .thenThrow('Failed to store data in messages table.');
      },
      act: (bloc) => bloc.add(const CreateConversation(
        title: 'Title 1',
        type: 'Simple Bot',
        chatList: <ChatModel>[
          ChatModel(msg: 'Hi', chatIndex: 0),
          ChatModel(msg: 'Hi, how can I assist you?', chatIndex: 1),
        ],
      )),
      expect: () => [
        ConversationListLoading(),
        const ConversationListError(
          'Something went wrong: Failed to store data in messages table.',
        )
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListLoaded] 
      when DeleteConversation event is added''',
      build: () => conversationListBloc,
      setUp: () {
        getConversationListFromDB();
        when(() => mockDatabaseHelper.deleteConversation(any()))
            .thenAnswer((_) => Future.value());
      },
      act: (bloc) => bloc
        ..add(FetchConversations())
        ..add(const DeleteConversation(id: 1)),
      skip: 2,
      expect: () => [
        ConversationListLoading(),
        ConversationListLoaded(
          conversations: [
            ConversationModel(
              id: 3,
              title: 'Title 3',
              type: 'Simple Bot',
              messages: const <ChatModel>[],
            ),
            ConversationModel(
              id: 2,
              title: 'Title 2',
              type: 'Simple Bot',
              messages: const <ChatModel>[],
            ),
          ],
        ),
      ],
    );

    blocTest<ConversationListBloc, ConversationListState>(
      '''emits [ConversationListLoading, ConversationListError] 
      when DeleteConversation event is failed''',
      build: () => conversationListBloc,
      setUp: () {
        getConversationListFromDB();
        when(() => mockDatabaseHelper.deleteConversation(any()))
            .thenThrow('Failed to delete from database.');
      },
      act: (bloc) => bloc
        ..add(FetchConversations())
        ..add(const DeleteConversation(id: 1)),
      skip: 2,
      expect: () => [
        ConversationListLoading(),
        const ConversationListError(
          'Something went wrong: Failed to delete from database.',
        ),
      ],
    );
  });
}
