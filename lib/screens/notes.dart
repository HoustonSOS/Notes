import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/model/notes.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  var model = Notes();

  _createDialog(BuildContext context) {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          var note = TextEditingController();
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nothing to add"), duration: Duration(milliseconds: 500),));
                      Navigator.pop(context);
                    }else {
                      setState(() {
                        model.add(note.text.trim());
                      });
                      Navigator.pop(context);
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
    setState(() {
      model.init();
    });
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
              child: const Text("Clear", style: TextStyle(color: Colors.white, fontSize: 15),),
              onPressed: (){
                if(model.notes.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nothing to clear"), duration: Duration(milliseconds: 500),));
                }else {
                  setState(() {
                    model.clear();
                  });
                }
              }
          ),
        ],
      ),
      body: model.notes.isEmpty
          ? const Center(
              child: Text("No notes", style: TextStyle(color: Colors.white),),
            )
          : ListView.builder(
          itemCount: model.notes.length,
          itemBuilder: (context, index) {
            var note = model.notes[index].body;
            var editing = TextEditingController(text: note);
            return Dismissible(
              background: Container(color: Colors.redAccent, child: const Icon(CupertinoIcons.delete, color: Colors.white,),),
              key: Key(note),
              child: ListTile(
                leading: const Icon(
                  Icons.circle,
                  color: Colors.blueGrey,
                  size: 15,
                ),
                minLeadingWidth: 10,
                title: Text(note, style: const TextStyle(color: Colors.white),),
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
                                  model.edit(model.notes[index], editing.text.trim());
                                  Navigator.pop(context);
                                },
                                child: const Icon(CupertinoIcons.pencil, color: Colors.blue,)
                            ),
                            CupertinoDialogAction(
                                onPressed: (){
                                  model.delete(model.notes[index]);
                                },
                                child: const Icon(CupertinoIcons.delete, color: Colors.blue,)
                            ),
                          ],
                        );
                      });
                },
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction){
                model.delete(model.notes[index]);
              },
            );
          }),
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
