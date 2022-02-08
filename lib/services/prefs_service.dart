import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs with ChangeNotifier{

  static push(String note) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("notes", note);
  }

  static Future<String> get() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('notes') ?? "";
  }

  static clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}