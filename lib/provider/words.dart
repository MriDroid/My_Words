import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';

// Models
import '../models/http_exception.dart';

class Word with ChangeNotifier {
  String id;
  String en;
  String ar;
  DateTime createdAt;

  Word({this.id, this.en, this.ar, this.createdAt});
}

class Words with ChangeNotifier {
  final String mainUrl = 'https://mywords-ac7e4-default-rtdb.firebaseio.com/';
  List<Word> _words = [];

  List<Word> get words => [..._words];

  Word findById(String id) => _words.firstWhere((element) => element.id == id);

  List<Word> filterWords(String word) {
    return [
      ..._words
          .where((element) => RegExp('[a-zA-Z]').hasMatch(word)
              ? element.en.toLowerCase().contains(word)
              : element.ar.contains(word))
          .toList()
    ];
  }

  Future<void> fetchWords() async {
    final url = '$mainUrl/words.json';
    try {
      final response = await http.get(url);
      _words.clear();
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((id, data) => _words.add(
            Word(
                id: id,
                en: data['en'],
                ar: data['ar'],
                createdAt: DateTime.parse(data['createdAt'])),
          ));
      _words.sort((f, s) => f.en.compareTo(s.en));
      notifyListeners();
    } catch (e) {
      throw HttpException('Please check your internet connection');
    }
  }

  Future<void> addWord(Word word) async {
    final url = '$mainUrl/words.json';
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'en': word.en,
              'ar': word.ar,
              'createdAt': DateTime.now().toString()
            },
          ));
      word.id = json.decode(response.body)['name'];
      _words.add(word);
      _words.sort((f, s) => f.en.compareTo(s.en));
      notifyListeners();
    } catch (e) {
      throw HttpException('Please try again');
    }
  }

  Future<void> updateWord(Word word, String id) async {
    final url = '$mainUrl/words/$id.json';
    final _editedWordIndex = _words.indexWhere((element) => element.id == id);
    try {
      await http.patch(url,
          body: json.encode(
            {
              'en': word.en,
              'ar': word.ar,
            },
          ));
      _words[_editedWordIndex] = word;
      _words.sort((f, s) => f.en.compareTo(s.en));
      notifyListeners();
    } catch (e) {
      throw HttpException('Please try again');
    }
  }

  Future<void> deleteWord(String id) async {
    final url = '$mainUrl/words/$id.json';
    final _deletedWordIndex = _words.indexWhere((element) => element.id == id);
    try {
      await http.delete(url);
      _words.removeAt(_deletedWordIndex);
      notifyListeners();
    } catch (e) {
      throw HttpException('Please try again');
    }
  }
}
