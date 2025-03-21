import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordly/data/models/word_detail.dart';


class WordService {

// Fetching Word's Information
  Future<List<WordDetails>> fetchSystemWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/${word.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        if (data.isNotEmpty) {
          return data.map((item) => WordDetails.fromJson(item)).toList();
        }
      }
      return []; 
    } catch (e) {
      debugPrint("Error fetching word definition: $e");
      return []; 
    }
  }




//Checking Word is Valid or Not
 static Future<bool?> checkIsValidWord(String word) async{
     try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );

      debugPrint("api called");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        debugPrint("${response.statusCode}");
        return true;
      } else if (response.statusCode == 404) {
        debugPrint("response is 404");
        return false;
      } else {
        debugPrint("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
