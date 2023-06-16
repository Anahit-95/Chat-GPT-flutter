import 'package:bloc_test/bloc_test.dart';
import 'package:chat_gpt_api/blocks/conversation_bloc/conversation_bloc.dart';
import 'package:chat_gpt_api/models/chat_model.dart';
import 'package:chat_gpt_api/models/conversation_model.dart';
import 'package:chat_gpt_api/services/db_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late ConversationBloc conversationBloc;
  late MockDatabaseHelper mockDatabaseHelper;
  late ConversationModel conversation;

  setUp(() {
    conversation = ConversationModel(
      id: 1,
      title: 'Title 1',
      type: 'Simple Bot',
      // ignore: prefer_const_literals_to_create_immutables
      messages: [],
    );
    mockDatabaseHelper = MockDatabaseHelper();
    conversationBloc = ConversationBloc(
      dbHelper: mockDatabaseHelper,
      conversation: conversation,
      systemMessage: 'You are a helpfull assistant',
    );
  });

  List<ChatModel> fetchedMessages = [
    ChatModel(id: 1, msg: 'Hi', chatIndex: 0),
    ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
  ];

  Future<void> fetchMessagesFromDB() async {
    when(
      () => mockDatabaseHelper.getMessagesByConversation(conversation.id),
    ).thenAnswer(
      (invocation) async => [...fetchedMessages],
    );
  }

  group('ConversationBloc Testing:', () {
    test('Checking ConversationBloc initial state - ConversationLoading', () {
      expect(conversationBloc.state, ConversationLoading());
    });

    group('FetchConversation event testing:', () {
      blocTest(
        '''emits [ConversationLoading, ConversationLoaded]
      when FetchConversion event is called
      and getting the messages from database''',
        build: () => conversationBloc,
        act: (bloc) => bloc.add(FetchConversation()),
        setUp: () async {
          await fetchMessagesFromDB();
        },
        expect: () => [
          ConversationLoading(),
          ConversationLoaded(
            conversation: conversation.copyWith(
              messages: fetchedMessages,
            ),
          ),
        ],
      );

      blocTest(
        '''emits [ConversationLoading, ConversationError]
      when FetchConversion event failed
      to get messages from database''',
        build: () => conversationBloc,
        act: (bloc) => bloc.add(FetchConversation()),
        setUp: () {
          when(
            () => mockDatabaseHelper.getMessagesByConversation(conversation.id),
          ).thenThrow('Unable to get messages from database');
        },
        expect: () => [
          ConversationLoading(),
          const ConversationError(
            'Failed to get messages: Unable to get messages from database',
          ),
        ],
      );
    });

    group('AddUserMessage event testng:', () {
      blocTest(
        '''emits [ConversationLoading, ConversationLoaded, ChatWaiting]
        when AddUserMessage event is called,
        adds the new message to database and message list''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(FetchConversation());
          bloc.add(AddUserMessage(msg: 'How are you?'));
        },
        setUp: () async {
          await fetchMessagesFromDB();
          when(() => mockDatabaseHelper.createMessage(conversation.id,
              ChatModel(msg: 'How are you?', chatIndex: 0))).thenAnswer(
            (invocation) => Future.value(3),
          );
        },
        expect: () => [
          ConversationLoading(),
          ConversationLoaded(
            conversation: conversation.copyWith(
              messages: [
                ChatModel(id: 1, msg: 'Hi', chatIndex: 0),
                ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
                ChatModel(id: 3, msg: 'How are you?', chatIndex: 0),
              ],
            ),
          ),
          ConversationWaiting(),
        ],
      );

      blocTest(
        '''emits [ConversationError]
        when AddUserMessage event is called,
        and failed to store message in database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(const AddUserMessage(msg: 'How are you?'));
        },
        setUp: () async {
          when(
            () => mockDatabaseHelper.createMessage(
              conversation.id,
              ChatModel(msg: 'How are you?', chatIndex: 0),
            ),
          ).thenThrow('Failed to store message in database.');
        },
        expect: () => [
          const ConversationError(
            'Failed to load message: Failed to store message in database.',
          ),
        ],
      );
    });

    group('DeleteMesage event testing', () {
      blocTest(
        '''emits [ConversationWaiting, ConversationLoaded] 
        when DeleteMessage is called, 
        deletes message from list and database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(FetchConversation());
          bloc.add(
            const DeleteMessage(
              msg: ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
            ),
          );
        },
        setUp: () async {
          await fetchMessagesFromDB();
          when(() => mockDatabaseHelper.deleteMessage(conversation.id, 2))
              .thenAnswer((_) => Future.value());
        },
        skip: 2,
        expect: () => [
          ConversationWaiting(),
          ConversationLoaded(
            conversation: conversation.copyWith(
              messages: [
                ChatModel(id: 1, msg: 'Hi', chatIndex: 0),
              ],
            ),
          ),
        ],
      );

      blocTest(
        '''emits [ConversationWaiting, ConversationError] 
        when DeleteMessage failed to delete message from database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(
            const DeleteMessage(
              msg: ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
            ),
          );
        },
        setUp: () async {
          when(() => mockDatabaseHelper.deleteMessage(conversation.id, 2))
              .thenThrow('Failed to delete message from database');
        },
        expect: () => [
          ConversationWaiting(),
          const ConversationError(
            'Failed to delete message: Failed to delete message from database',
          ),
        ],
      );
    });

    group('ClearMessages event testing:', () {
      blocTest(
        '''emits [ConversationWaiting, ConversationLoaded]
        when the ClearMessages event is called, empties the list
        and delete the messages from the database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(FetchConversation());
          bloc.add(ClearMessages());
        },
        setUp: () async {
          await fetchMessagesFromDB();
          when(() => mockDatabaseHelper.deleteMessages(conversation.id))
              .thenAnswer(
            (_) => Future.value(),
          );
        },
        skip: 2,
        expect: () => [
          ConversationWaiting(),
          ConversationLoaded(conversation: conversation.copyWith(messages: [])),
        ],
      );

      blocTest(
        '''emits [ConversationWaiting, ConversationError]
        when the ClearMessages event failed to
        delete the messages from the database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(ClearMessages());
        },
        setUp: () {
          when(() => mockDatabaseHelper.deleteMessages(conversation.id))
              .thenThrow('Failed to reach the database.');
        },
        expect: () => [
          ConversationWaiting(),
          const ConversationError(
            'Failed to clear messages from database: Failed to reach the database.',
          ),
        ],
      );
    });

    group('UpdateMessageList checking', () {
      blocTest(
        '''emits [ConversationWaiting, ConversationLoaded] 
        when UpdateMessageList event is called, 
        updates conversation message list in database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(UpdateMessageList());
        },
        setUp: () {
          fetchMessagesFromDB();
          when(() =>
                  mockDatabaseHelper.updateMessageList(conversation.id, any()))
              .thenAnswer((_) => Future.value());
          when(() =>
                  mockDatabaseHelper.getMessagesByConversation(conversation.id))
              .thenAnswer(
            (_) async => const [
              ChatModel(id: 1, msg: 'Hi', chatIndex: 0),
              ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
              ChatModel(id: 3, msg: 'How are you?', chatIndex: 0),
              ChatModel(id: 4, msg: 'I am fine.', chatIndex: 1),
            ],
          );
        },
        expect: () => [
          ConversationWaiting(),
          ConversationLoaded(
            conversation: ConversationModel(
              id: 1,
              title: 'Title 1',
              type: 'Simple Bot',
              messages: const [
                ChatModel(id: 1, msg: 'Hi', chatIndex: 0),
                ChatModel(id: 2, msg: 'Hello', chatIndex: 1),
                ChatModel(id: 3, msg: 'How are you?', chatIndex: 0),
                ChatModel(id: 4, msg: 'I am fine.', chatIndex: 1),
              ],
            ),
          ),
        ],
      );

      blocTest(
        '''emits [ConversationWaiting, ConversationLoaded] 
        when UpdateMessageList failed to update 
        conversation message list in database''',
        build: () => conversationBloc,
        act: (bloc) {
          bloc.add(UpdateMessageList());
        },
        setUp: () {
          fetchMessagesFromDB();
          when(() =>
                  mockDatabaseHelper.updateMessageList(conversation.id, any()))
              .thenThrow('Unable to save messages');
          when(() =>
                  mockDatabaseHelper.getMessagesByConversation(conversation.id))
              .thenAnswer(
            (_) async => fetchedMessages,
          );
        },
        expect: () => [
          ConversationWaiting(),
          ConversationError('Failed to save messages: Unable to save messages'),
        ],
      );
    });
  });
}
