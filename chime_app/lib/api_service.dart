import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
// import 'package:chime_app/language_selection_model.dart';

class ApiService {
  final FlutterTts _flutterTts = FlutterTts();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late List<Map> _voices;
  late Map _currentVoice;

  String? nativeLanguage;
  String? learningLanguage;
  String? languageLevel;

  ApiService._internal();

  static const String _baseUrl = 'https://chime-93ee9d997c42.herokuapp.com';

  void initTTS(String? languageLocale) {
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        var filteredVoices = voices
            .where((voice) => voice["locale"]
                .toLowerCase()
                .contains((languageLocale ?? "en").toLowerCase()))
            .toList();
        print(
            "Filtered voices based on language code: $languageLocale $filteredVoices ");
        if (filteredVoices.isNotEmpty) {
          _voices = filteredVoices;
          _currentVoice = _voices.first;
          setSpeechVoice(
              _currentVoice); // Assuming setVoice is a method that sets the voice for TTS.
          print("Voice set to: ${_currentVoice['name']}");
        } else if (filteredVoices.isEmpty) {
          print("No voices found for the language code: $languageLocale");
        }
      } catch (e) {
        print("Error fetching voices: $e");
      }
    });
  }

  void setSpeechVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
    _flutterTts.setLanguage(voice["locale"]);
    _flutterTts.setSpeechRate(Platform.isIOS ? 0.52 : 1.5);

    // _flutterTts.setSpeechRate(1);
  }

  Future<String> processAudio(XFile file) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/process-audio/'));
    request.files.add(http.MultipartFile.fromBytes(
        'audio', await file.readAsBytes(),
        filename: 'audio.wav'));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      // Decode the response data with utf8
      final decodedResponse = utf8.decode(responseData.bodyBytes);
      // Assuming the server returns a JSON with a "transcribed_text" key
      final transcribedText = jsonDecode(decodedResponse)['transcribed_text'];
      return transcribedText;
    } else {
      throw Exception('Failed to process audio');
    }
  }

  Future<Uint8List> generateSpeech(String text) async {
    final request = http.Request(
        'POST',
        Uri.parse('$_baseUrl/generate-speech/').replace(queryParameters: {
          'text': text,
        }))
      ..headers.addAll({"accept": "application/json"});

    final response = await request.send();

    if (response.statusCode == 200) {
      return response.stream.toBytes();
    } else {
      throw Exception('Failed to generate speech');
    }
  }

  Future<void> speakText(String text) async {
    await _flutterTts.speak(text);
  }

  Stream<String> generateConversationResponse(
      List<Map<String, String>> messages) async* {
    final Uri url =
        Uri.parse('$_baseUrl/generate-response/').replace(queryParameters: {
      'nativeLanguage': nativeLanguage,
      'learningLanguage': learningLanguage,
      'languageLevel': languageLevel
    });
    final request = http.Request('POST', url)
      ..headers.addAll({
        "Content-Type": "application/json",
        "Accept": "application/json",
      })
      ..body = jsonEncode(messages);

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      await for (var chunk in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        yield chunk;
      }
    } else {
      throw Exception('Failed to generate conversation response');
    }
  }

  Future<List<Map<String, dynamic>>> generateAnnotationResponse(
      String text) async {
    final Uri url = Uri.parse('$_baseUrl/generate-annotation/')
        .replace(queryParameters: {'text': text});
    final response =
        await http.post(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      try {
        // Decode the JSON response
        var decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        // Check if 'suggestions' key exists and is not empty
        if (decodedData.containsKey('suggestions') &&
            decodedData['suggestions'] is List) {
          List<Map<String, dynamic>> annotations =
              List<Map<String, dynamic>>.from(decodedData['suggestions']);
          return annotations;
        } else {
          // Return an empty list if 'suggestions' key doesn't exist or is not a list
          return [];
        }
      } catch (e) {
        print('Error parsing annotations: $e');
        return [];
      }
    } else {
      print(
          'Failed to generate annotations. Status code: ${response.statusCode}. Response body: ${response.body}');
      throw Exception(
          'Failed to generate annotations. Status code: ${response.statusCode}');
    }
  }
}
