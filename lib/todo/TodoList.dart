/*
 * TodoList is a class that contains a list of task.
 * It provide the main page with a passable object.
 */
import 'dart:convert';

import 'Todo.dart';

/// A class that contains a list of task past to the page .
class TodoList {
  /// Store the [todoList]
  List<Todo> todoList;

  ///  Constructor with no parameter
  TodoList() {
    todoList = List<Todo>();
  }

  ///  Constructor with Map(called by [json.decode] )
  TodoList.fromJson(Map<String, dynamic> jsonMap) {
    todoList = new List<Todo>();
    jsonMap.forEach((index, todoJson) {
      // Decode each task in the list
      Map todoMap = json.decode(todoJson);
      todoList.insert(int.parse(index), new Todo.fromJson(todoMap));
    });
  }
}
