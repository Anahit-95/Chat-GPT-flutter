import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chat_model.dart';
import '../models/conversation_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create tables and perform initial setup
        await db.execute(
            'CREATE TABLE IF NOT EXISTS conversations (id INTEGER PRIMARY KEY, title TEXT, type TEXT)');
        await db.execute(
            'CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, conversationId INTEGER, msg TEXT, chatIndex INTEGER)');
      },
    );
  }

  Future<int> createConversation(String title, String type) async {
    final db = await database;
    final conversationId =
        await db.insert('conversations', {'title': title, 'type': type});
    return conversationId;
  }

  Future<void> updateConversation(int id, String title) async {
    final db = await database;
    await db.update('conversations', {'title': title},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteConversation(int id) async {
    final db = await database;
    await db.delete('conversations', where: 'id = ?', whereArgs: [id]);
    await db.delete('messages', where: 'conversationId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getConversationList() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('conversations');
    final List<Map<String, dynamic>> conversationList = [];

    for (var row in result) {
      final Map<String, dynamic> conversation = {
        'id': row['id'],
        'title': row['title'],
        'type': row['type']
      };
      // final String title = row['title'];
      conversationList.add(conversation);
    }

    return conversationList;
  }

  // Future<int> createMessage(int conversationId, ChatModel chatModel) async {
  //   final db = await database;
  //   final id = await db.insert('messages', {
  //     'conversationId': conversationId,
  //     'msg': chatModel.msg,
  //     'chatIndex': chatModel.chatIndex,
  //   });
  //   return id;
  // }

  Future<void> createMessageList(
      int conversationId, List<ChatModel> chatList) async {
    final db = await database;
    final batch = db.batch();

    for (var chat in chatList) {
      batch.insert('messages', chat.toMap(conversationId));
    }

    await batch.commit();
  }

  Future<List<ChatModel>> getMessagesByConversation(int conversationId) async {
    final db = await database;
    List<Map<String, dynamic>> messages = await db.query('messages',
        where: 'conversationId = ?', whereArgs: [conversationId]);
    List<ChatModel> chatListDB = [];
    for (var row in messages) {
      ChatModel message =
          ChatModel(msg: row['msg'], chatIndex: row['chatIndex']);
      chatListDB.add(message);
    }
    return chatListDB;
  }

  Future<ConversationModel> getConversation(int conversationId) async {
    final db = await database;

    // Retrieve conversation details
    List<Map<String, dynamic>> conversationResult = await db.query(
      'conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
    );

    if (conversationResult.isEmpty) {
      throw Exception('Conversation not found');
    }

    // Extract conversation details
    final conversationRow = conversationResult.first;
    final String title = conversationRow['title'];
    final String type = conversationRow['type'];

    // Retrieve chat messages
    List<ChatModel> messages = await getMessagesByConversation(conversationId);

    // Create and return ConversationModel object
    return ConversationModel(
      id: conversationId,
      title: title,
      type: type,
      messages: messages,
    );
  }
}
