// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:google_fonts/google_fonts.dart";

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final addTodoFieldController = TextEditingController();
  List tasks = [];

  bool hide_completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 26)),
        centerTitle: true,
        actions: [Image.asset('assets/images/logo.png'), SizedBox(width: 10)],
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Today",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 30),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  hide_completed = !hide_completed;
                }),
                child: Text(hide_completed ? "Lit completed" : "Dim completed",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue[600],
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ListBody(
            children: tasks.length == 0
                ? [
                    Text(
                      "Nothing todo today.",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ]
                : todoItems(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTodoDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: addTodoFieldController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "What todo..."
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      tasks.add(
                          {"text": addTodoFieldController.text, "done": false});
                      addTodoFieldController.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> todoItems() {
    List<Widget> items = [];
    for (int i = 0; i < tasks.length; i++) {
      // if(hide_completed && task['done']) continue;
      items.add(todoItem(tasks[i], i));
    }

    return items;
  }

  Widget todoItem(Map task, index) {
    bool visible = true;
    if (hide_completed && task['done']) visible = false;

    return AnimatedOpacity(
      duration: Durations.medium2,
      opacity: visible ? 1 : .3,
      child: ListTile(
        leading: Checkbox(
          onChanged: (value) => {
            setState(() {
              task['done'] = value!;
            })
          },
          value: task['done'],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(task['text']),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              tasks.removeAt(index);
            });
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
