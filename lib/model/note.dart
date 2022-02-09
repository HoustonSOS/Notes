import 'package:equatable/equatable.dart';

class Note with EquatableMixin{

  final String body;
  final DateTime createdOn;
  final DateTime? editedOn;

  const Note({required this.body, required this.createdOn, this.editedOn});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
          body: json['body'],
          createdOn: DateTime.parse(json['createdOn']),
          editedOn: DateTime.parse(json['editedOn']),
      );
  }

  Note changeOnly(String body, DateTime edited){
    return Note(body: body, createdOn: createdOn,editedOn: edited);
  }

  Map<String, dynamic> toJson(){
    DateTime p;
    if(editedOn == null){
      p = DateTime(0);
    }else{
      p = editedOn!;
    }
    return {
      'body' : body,
      'createdOn' : createdOn.toString(),
      'editedOn' : p.toString(),
    };
  }

  @override
  List<Object?> get props => [body, createdOn, editedOn];
}