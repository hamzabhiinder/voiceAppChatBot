import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;



class ApiService {
  static String baseUrl = "https://api.openai.com/v1/completions";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $api_Key'
  };

  static sendMessage(String? message) async {
    var response = await http.post(Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": message,
          "max_tokens": 100,
          "temperature": 0,
          "top_p": 1,
          "n": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": ["Human:", "AI:"]
        }));
    log("${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      log("Data: " + data['choices'][0]['text']);
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      if (kDebugMode) {
        print("Failed to fetch Data from server");
      }
    }
  }
}
