import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'TodoConvert.dart';
import 'TodoList.dart';

// Considering that there is [writeAsString] and [readAsString] in the package:
// path_provider, I use JSON to store all data of this TodoList.

/// This class store TodoList with package:path_provider
class TodoListStorage {
  /// Local path of storage
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  /// Local file of storage
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todolist.txt');
  }

  ///  read the TodoList
  Future<TodoList> readTodoList() async {
    try {
//      open the file
      final file = await _localFile;
//      read the file
      String todoListJson = await file.readAsString();
//      convert the [todoListJson] into <String,dynamic> Map
      Map<String, dynamic> todoListMap = json.decode(todoListJson);

      return new TodoList.fromJson(todoListMap);
    } catch (e) {
//       when no file stored before
      print("no file read");
      var todoList = new TodoList();
      return todoList;
    }
  }

  /// Local path of storage
  Future<File> writeTodoList(TodoList todoList) async {
//    open the file
    final file = await _localFile;
//    Write the file
    String jsonTodoList = json.encode(
      todoList,
      toEncodable: (todoList) {
        return todoListToMap(todoList);
      },
    );
    return file.writeAsString(jsonTodoList);
  }
}
