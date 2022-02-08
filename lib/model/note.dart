class Note{

  final String body;

  const Note({required this.body});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
          body: json['body'],
      );
  }

  Map<String, dynamic> toJson(){
    return {'body' : body};
  }
}