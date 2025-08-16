import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'debate_format.dart';

class FormatStorage {
  static const String _storageKey = 'debate_formats';

  static Future<List<DebateFormat>> loadFormats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return _getDefaultFormats();
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => DebateFormat.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultFormats();
    }
  }

  static Future<bool> saveFormats(List<DebateFormat> formats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = formats.map((format) => format.toJson()).toList();
    final jsonString = json.encode(jsonList);
    return await prefs.setString(_storageKey, jsonString);
  }

  static Future<bool> addFormat(DebateFormat format) async {
    final formats = await loadFormats();
    formats.add(format);
    return await saveFormats(formats);
  }

  static Future<bool> removeFormat(String shortName) async {
    final formats = await loadFormats();
    formats.removeWhere((format) => format.shortName == shortName);
    return await saveFormats(formats);
  }

  static Future<bool> updateFormat(
      String shortName, DebateFormat newFormat) async {
    final formats = await loadFormats();
    final index = formats.indexWhere((format) => format.shortName == shortName);
    if (index != -1) {
      formats[index] = newFormat;
      return await saveFormats(formats);
    }
    return false;
  }

  static List<DebateFormat> _getDefaultFormats() {
    return [
      DebateFormat(
        fullName: 'British Parliamentary',
        shortName: 'BP',
        timings: [
          [0, 30],
          [4, 30],
          [5, 0],
          [5, 15]
        ],
      ),
      DebateFormat(
        fullName: 'World Schools',
        shortName: 'WS',
        timings: [
          [1, 0],
          [7, 0],
          [8, 0],
          [8, 15]
        ],
      ),
    ];
  }
}
