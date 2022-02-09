import 'dart:convert';
import 'package:localization/services/prefs_service.dart';
import 'note.dart';

class Notes{
  List<Note> notes = [];
  Set<Note> selected = {};

  Future<bool> init() async {
    var saved = await Prefs.get();
    notes = _decode(saved);
    return notes.isNotEmpty;
  }

  void add(String note){
    var _note = Note(body: note, createdOn: DateTime.now());
    notes.add(_note);
    Prefs.push(_encode());
  }

  void delete(Note note){
    for(var item in notes){
      if(note == item){
        notes.remove(item);
        Prefs.push(_encode());
        break;
      }
    }
  }

  void edit(Note from, String to) {
    for(int i = 0; i < notes.length; i++){
      if(from == notes[i]){
        notes[i] = notes[i].changeOnly(to, DateTime.now());
        Prefs.push(_encode());
        break;
      }
    }
  }

  void deleteAll(){
    for(var note in selected){
      notes.removeWhere((element) => note == element);
    }
    selected.clear();
    Prefs.push(_encode());
  }

  void clear(){
    notes.clear();
    Prefs.clear();
  }

  String _encode(){
    var json = notes.map((note) => jsonEncode(note.toJson()));
    return jsonEncode(json.toList());
  }

  List<Note> _decode(String input){
    List<Note> _notes = [];
    var json = jsonDecode(input);
    for(var note in json){
      var map = jsonDecode(note);
      _notes.add(Note.fromJson(map));
    }
    return _notes;
  }
}