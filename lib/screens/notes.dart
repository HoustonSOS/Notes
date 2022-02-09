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
  bool darkMode = false;

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
                onPressed: () {
                  if (note.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Nothing to add"),
                      duration: Duration(milliseconds: 500),
                    ));
                    Navigator.pop(context);
                  } else {
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
    WidgetsBinding.instance?.addPostFrameCallback((_){
      setState(() {
        model.init();
      });
    });
    print(model.notes);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.yellow.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
        title: const Text("Notes"),
        leadingWidth: 100.0,
        leading: model.selected.isNotEmpty
            ? TextButton(
                onPressed: () {
                  setState(() {
                    model.deleteAll();
                  });
                },
                child: Text(
                  "Delete[${model.selected.length}]",
                  style:
                      TextStyle(color: darkMode ? Colors.white : Colors.black),
                ))
            : IconButton(
                onPressed: () {
                  setState(() {
                    darkMode = !darkMode;
                  });
                },
                icon: darkMode ? Icon(Icons.wb_sunny) : Icon(Icons.dark_mode),
                splashRadius: 20.0,
              ),
        actions: [
          model.selected.isEmpty
              ? CupertinoButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black,
                        fontSize: 15),
                  ),
                  onPressed: () {
                    if (model.notes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Nothing to clear"),
                        duration: Duration(milliseconds: 500),
                      ));
                    } else {
                      setState(() {
                        model.clear();
                      });
                    }
                  })
              : model.selected.length == model.notes.length
                  ? CupertinoButton(
                      child: Text(
                        "Unselect",
                        style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontSize: 15),
                      ),
                      onPressed: () {
                        setState(() {
                          model.selected.clear();
                        });
                      })
                  : CupertinoButton(
                      child: Text(
                        "Select All",
                        style: TextStyle(
                            color: darkMode ? Colors.white : Colors.black,
                            fontSize: 15),
                      ),
                      onPressed: () {
                        setState(() {
                          model.selected.addAll(model.notes);
                        });
                      })
        ],
      ),
      body: model.notes.isEmpty
          ? Center(
              child: Text(
                "No notes",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: model.notes.length,
              itemBuilder: (context, index) {
                var note = model.notes[index];
                var selected = model.selected;
                var date = note.createdOn.toString();
                var formattedDate = date.split(" ");
                var editing = TextEditingController(text: note.body);
                return Dismissible(
                  background: Container(
                    color: Colors.redAccent,
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: Key(note.body),
                  child: ListTile(
                    tileColor: selected.contains(note)
                        ? darkMode
                            ? Colors.grey.shade900
                            : Colors.yellow.shade100
                        : null,
                    leading: const Icon(
                      Icons.circle,
                      color: Colors.blueGrey,
                      size: 15,
                    ),
                    minLeadingWidth: 10,
                    subtitle: Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        formattedDate[0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    title: Text(
                      note.body,
                      style: TextStyle(
                          color: darkMode ? Colors.white : Colors.black),
                    ),
                    onLongPress: () {
                      if (!selected.contains(note)) {
                        setState(() {
                          selected.add(note);
                        });
                      } else {
                        setState(() {
                          selected.remove(note);
                        });
                      }
                    },
                    onTap: () {
                      if (selected.isEmpty) {
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
                                      onPressed: () {
                                        setState(() {
                                          model.edit(model.notes[index],
                                              editing.text.trim());
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        CupertinoIcons.pencil,
                                        color: Colors.blue,
                                      )),
                                  CupertinoDialogAction(
                                      onPressed: () {
                                        setState(() {
                                          model.delete(model.notes[index]);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.blue,
                                      )),
                                ],
                              );
                            });
                      } else {
                        if (!selected.contains(note)) {
                          setState(() {
                            selected.add(note);
                          });
                        } else {
                          setState(() {
                            selected.remove(note);
                          });
                        }
                      }
                    },
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      if (selected.contains(note)) {
                        selected.remove(note);
                      }
                      model.delete(model.notes[index]);
                    });
                  },
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        onPressed: () {
            if(model.selected.isNotEmpty){
              setState(() {
                model.selected.clear();
              });
            }
          _createDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
