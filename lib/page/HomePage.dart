import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wipe_done_new/page/TodoPage.dart';
import 'package:wipe_done_new/theme.dart';
import 'package:wipe_done_new/todo/Todo.dart';
import 'package:wipe_done_new/todo/TodoList.dart';
import 'package:wipe_done_new/todo/TodoListStorage.dart';

/// Theme index for instance theme change
int themeIndex = 0;

/// Main App called by main => runApp()
class ThisApp extends StatefulWidget {
  // Restart this app to update
  static restartApp(BuildContext context) {
    // Declare a state
    final _ThisAppState state =
        context.ancestorStateOfType(const TypeMatcher<_ThisAppState>());

    state.restartApp();
  }

  @override
  _ThisAppState createState() => new _ThisAppState();
}

class _ThisAppState extends State<ThisApp> {
  /// Binding [ThisApp] to restart app by key
  Key key = new UniqueKey();

  /// Assign a new key
  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      /// Binding this MaterialApp with unique key
      key: key,
      title: '任务清单',
      home: new MyHomePage(
        storage: TodoListStorage(),
      ),
      theme: themeList[themeIndex],
    );
  }
}

/// Build the home page
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.storage}) : super(key: key);

  /// Storage service
  final TodoListStorage storage;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoList _todoList;

  //  Update app theme
  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeIndex = (prefs.getInt('counter') ?? 0);
    });
  }

  // Change the [themeIndex]

  void setTheme(int newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeIndex = newTheme;

    prefs.setInt('counter', themeIndex);
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    widget.storage.readTodoList().then((TodoList todoList) {
      setState(() {
        _todoList = todoList;
      });
    });
  }

  // Create a new task with [title]

  Future<File> _addTodo([String title]) async {
    setState(() {
      if (title == "") title = "未命名任务";
      _todoList.todoList.add(Todo(title));
    });

    return widget.storage.writeTodoList(_todoList);
  }

  // Delete a task in list by index

  Future<File> _deleteTodo(int index) async {
    setState(() {
      _todoList.todoList.removeAt(index);
    });

    return widget.storage.writeTodoList(_todoList);
  }

  // Change [done] state of task

  Future<File> _changeTodoDone(int index) async {
    setState(() {
      _todoList.todoList[index].done = !_todoList.todoList[index].done;
    });

    return widget.storage.writeTodoList(_todoList);
  }

  // Change [star] state of task

  Future<File> _changeTodoStar(int index) async {
    setState(() {
      _todoList.todoList[index].star = !_todoList.todoList[index].star;
    });

    return widget.storage.writeTodoList(_todoList);
  }

  // Push out a Dialog window to create a new task

  void _showNewTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // TextEditingController => TextField
        var textController = new TextEditingController(
          text: "",
        );
        return new AlertDialog(
          title: Text("新建任务"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: new TextField(
                    onSubmitted: (text) {
                      // create a new task
                      _addTodo(text);
                      // back to the main page
                      Navigator.pop(context);
                    },
                    maxLength: 20,
                    style: new TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.8,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w400,
                    ),
                    controller: textController,
                    autofocus: true,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text("确认"),
              onPressed: () {
                _addTodo(textController.text);
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Push out a Dialog window to change app theme

  void _changeThemeIndex() {
    showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: Text("选择主题"),
          content: new SingleChildScrollView(
              child: new ListBody(
                  children: themeList.map((ThemeData themeData) {
            return new Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    setTheme(themeList.indexOf(themeData));
                  });
                  ThisApp.restartApp(context);

                  Navigator.pop(context);
                },
                child: new CircleAvatar(
                  backgroundColor: themeData.primaryColor,
                  // if selected show done;
                  // if not selected show transparent.
                  child: themeList.indexOf(themeData) == themeIndex
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.done,
                          color: Colors.transparent,
                        ),
                ),
              ),
            );
          }).toList())),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
//        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "任务清单",
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
            onPressed: _changeThemeIndex,
          ),
        ],
      ),
//      backgroundColor: Colors.white,
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new ListView.builder(
          // if null ,set [itemCount] as 0
          itemCount: _todoList != null ? _todoList.todoList.length : 0,
          itemBuilder: (context, pageIndex) {
            int index = pageIndex;
            return new Card(
//              color: Colors.white70,
              child: new Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: new Dismissible(
                  key: Key(index.toString()),
                  secondaryBackground: const ListTile(
                    trailing: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                  background: const ListTile(
                    leading: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                  child: new ListTile(
                    onTap: () {
                      // Navigate to [TodoPage]
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoPage(
                            todo: _todoList.todoList[index],
                          ),
                        ),
                      );

                      widget.storage.writeTodoList(_todoList);
                    },
                    title: new Text(
                      _todoList.todoList[index].title,
                      style: TextStyle(
                          fontSize: 18.0,
                          // if done, lineThrough decoration
                          // if not done, no decoration
                          decoration: _todoList.todoList[index].done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    leading: new IconButton(
                      icon: Icon(
                        // if done, radio checked
                        // if not done, radio unchecked
                        _todoList.todoList[index].done
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        _changeTodoDone(index);
                      },
                    ),
                    trailing: new IconButton(
                      icon: _todoList.todoList[index].star
                          ? Icon(
                              Icons.star,
                              color: Colors.amber,
                            )
                          : Icon(
                              Icons.star_border,
                              color: Colors.black26,
                            ),
                      onPressed: () {
                        _changeTodoStar(index);
                      },
                    ),
                  ),
                  onDismissed: (dismissDirection) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Task ${_todoList.todoList[index].title} dismissed")));
                    setState(() {
                      _deleteTodo(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        foregroundColor: Colors.white,
//        backgroundColor: Colors.red,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _showNewTodoDialog,
        tooltip: 'Add new Task',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
