import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs with ChangeNotifier{

  static addNote(String note) async {
    var pref = await SharedPreferences.getInstance();
    if(pref.containsKey('notes')){
      var list = pref.getStringList('notes');
      list!.add(note);
      pref.setStringList('notes', list);
    }else{
      List<String> notes = [];
      notes.add(note);
      pref.setStringList('notes', notes);
    }
  }

  static Future<void> deleteNote(String note) async {
    var prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("notes");
    if(list != null && list.isNotEmpty){
      for (var element in list) {
        if(note == element){
          list.remove(element);
          break;
        }
      }
      prefs.setStringList('notes', list);
    }
  }

  static Future<void> editNote(String oldNote, String newNote) async{
    var prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('notes');
    if(list != null && list.isNotEmpty){
      for(int i = 0; i < list.length; i++){
        if(list[i] == oldNote){
          list[i] = newNote;
          break;
        }
      }
    }
    prefs.setStringList('notes', list!);
  }

  static Future<List<String>> getNotes() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notes') ?? [];
  }

  static Future<void> clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}