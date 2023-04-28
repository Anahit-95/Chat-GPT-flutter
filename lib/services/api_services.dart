import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';
import '../models/models_model.dart';
import '../constants/api_consts.dart';

class ApiService {
  static List<Map<String, String>> messages = [];
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/models'),
          headers: {'Authorization': 'Bearer $API_KEY'});

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      print('jsonResponse $jsonResponse');
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        log('temp ${value['id']}');
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log('error $error');
      rethrow;
    }
  }

  // Send Message completion

  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log('modelId $modelId');
      var response = await http.post(
        Uri.parse('$BASE_URL/completions'),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(jsonResponse['choices'].length, (index) {
          var utf8decoder = Utf8Decoder(allowMalformed: true);
          String decodedText = utf8decoder
              .convert(jsonResponse["choices"][index]["text"].codeUnits);
          return ChatModel(
            msg: decodedText,
            chatIndex: 1,
          );
        });
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message using ChatGPT API

  static Future<List<ChatModel>> sendMessageGPT(
      {required String message,
      required String modelId,
      String? systemMessage}) async {
    messages.add({
      'role': 'user',
      'content': message,
    });
    try {
      log('modelId $modelId');
      var response = await http.post(
        Uri.parse('$BASE_URL/chat/completions'),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {"role": "system", "content": systemMessage},
              ...messages,
              // {
              //   "role": "user",
              //   "content": message,
              // }
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(jsonResponse['choices'].length, (index) {
          var utf8decoder = Utf8Decoder(allowMalformed: true);
          String decodedText = utf8decoder.convert(
              jsonResponse['choices'][index]['message']['content'].codeUnits);

          messages.add({
            'role': 'assistant',
            'content': decodedText,
          });
          return ChatModel(msg: decodedText, chatIndex: 1);
        });
      }

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // audio transcription

  static Future<String> convertSpeechToText(String filePath) async {
    var url = Uri.parse('$BASE_URL/audio/transcriptions');
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(({"Authorization": "Bearer $API_KEY"}));
      request.fields['model'] = 'whisper-1';
      // request.fields['language'] = 'ru';
      request.files.add(await http.MultipartFile.fromPath("file", filePath));

      var utf8decoder = Utf8Decoder(allowMalformed: true);
      var response = await request.send();
      var newResponse = await http.Response.fromStream(response);
      final responseData = json.decode(newResponse.body);
      final responseText = utf8decoder.convert(responseData['text'].codeUnits);
      print(responseData);
      return responseText;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // translate the text from audio file in english

  static Future<String> translateSpeechToEnglish(String filePath) async {
    var url = Uri.parse('$BASE_URL/audio/translations');
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(({"Authorization": "Bearer $API_KEY"}));
      request.fields['model'] = 'whisper-1';
      // request.fields['language'] = 'en';
      request.files.add(await http.MultipartFile.fromPath("file", filePath));

      var utf8decoder = Utf8Decoder(allowMalformed: true);
      // String decodedText = utf8decoder.convert(
      //     jsonResponse['choices'][index]['message']['content'].codeUnits);
      var response = await request.send();
      var newResponse = await http.Response.fromStream(response);
      final responseData = json.decode(newResponse.body);
      final responseText = utf8decoder.convert(responseData['text'].codeUnits);
      print(responseData);
      return responseText;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static generateImage(String text, String size) async {
    var response = await http.post(
      Uri.parse('$BASE_URL/images/generations'),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        "Content-Type": "application/json"
      },
      body: jsonEncode(
        {
          "prompt": text,
          "n": 1,
          "size": size,
        },
      ),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return data['data'][0]['url'].toString();
    } else {
      print('Failed to fetch image');
    }
  }
}
