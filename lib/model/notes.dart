import 'dart:convert';
import 'package:localization/services/prefs_service.dart';
import 'note.dart';

class Notes{
  List<Note> notes = [];

  void init() async => notes = decode(await Prefs.get());

  void add(String note){
    var _note = Note(body: note, createdOn: DateTime.now());
    notes.add(_note);
    Prefs.push(encode());
  }
  void delete(Note note){
    for(var item in notes){
      if(note == item){
        notes.remove(item);
        Prefs.push(encode());
        break;
      }
    }
  }

  bool edit(Note from, String to){
    for(int i = 0; i < notes.length; i++){
      if(from == notes[i]){
        notes[i].changeOnly(to, DateTime.now());
        Prefs.push(encode());
        return true;
      }
    }
    return false;
  }

  void clear(){
    notes.clear();
    Prefs.clear();
  }
  String encode(){
    var json = notes.map((note) => jsonEncode(note.toJson()));
    return jsonEncode(json.toList());
  }

  List<Note> decode(String input){
    List<Note> _notes = [];
    var json = jsonDecode(input);
    for(var note in json){
      var map = jsonDecode(note);
      _notes.add(Note.fromJson(map));
    }
    return _notes;
  }
}