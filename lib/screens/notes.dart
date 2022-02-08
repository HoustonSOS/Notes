import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/services/prefs_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  var note = TextEditingController();

  List<String> notes = [];


  _createDialog(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Create a note"),
            content: CupertinoTextField(
              expands: true,
              maxLines: null,
              controller: note,
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: (){
                    if(note.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nothing to add"), duration: Duration(milliseconds: 500),));
                      Navigator.pop(context);
                    }else {
                      Prefs.addNote(note.text);
                      setState(() {
                        getAll();
                      });
                      Navigator.pop(context);
                      note.clear();
                    }
                  },
                  child: const Text('Add'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  Future<void> getAll() async {
    notes = await Prefs.getNotes();
  }

  void deleteNote(String note) {
    Prefs.deleteNote(note);
    for (var element in notes) {
      if (element == note) {
        setState(() {
          notes.remove(note);
        });
        break;
      }
    }
  }

  void editNote(String old, String _new) {
    Prefs.editNote(old, _new);
    for (int i = 0; i < notes.length; i++) {
      if (notes[i] == old) {
        setState(() {
          notes[i] = _new;
        });
        break;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
        title: const Text("Notes"),
        actions: [
          CupertinoButton(
              child: Text("Clear", style: TextStyle(color: Colors.white, fontSize: 15),),
              onPressed: (){
                if(notes.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nothing to clear"), duration: Duration(milliseconds: 500),));
                }else {
                  setState(() {
                    Prefs.clearAll();
                    notes.clear();
                  });
                }
              }
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text("No notes", style: TextStyle(color: Colors.white),),
            )
          : RefreshIndicator(
          child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            var note = notes[index];
            var editing = TextEditingController(text: note);
            return Dismissible(
              background: Container(color: Colors.redAccent, child: Icon(CupertinoIcons.delete, color: Colors.white,),),
              key: Key(note),
              child: ListTile(
                leading: const Icon(
                  Icons.circle,
                  color: Colors.blueGrey,
                  size: 15,
                ),
                minLeadingWidth: 10,
                title: Text(note, style: TextStyle(color: Colors.white),),
                onTap: (){
                  showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Edit"),
                          content: CupertinoTextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            controller: editing,
                          ),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: (){
                                  editNote(note, editing.text.trim());
                                  Navigator.pop(context);
                                },
                                child: Icon(CupertinoIcons.pencil, color: Colors.blue,)
                            ),
                            CupertinoDialogAction(
                                onPressed: (){
                                  deleteNote(note);
                                  Navigator.pop(context);
                                },
                                child: Icon(CupertinoIcons.delete, color: Colors.blue,)
                            ),
                          ],
                        );
                      });
                },
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction){
                deleteNote(note);
              },
            );
          }),
          onRefresh: () async {
            setState(() {
              getAll();
            });
          }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        onPressed: () {
          _createDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
