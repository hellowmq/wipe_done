import 'dart:convert';

import 'TodoList.dart';

/// This function is design for the [json.encode] as [toEncodable] parameter.
///
///   The  [toEncodable] parameter will be past to the json.encode(), so that
/// this function can not be one of the functions in the class [TodoList].
///
/// Actually, in dart:convert:
///
/// If value contains objects that are not directly encodable to a JSON
/// string (a value that is not a number, boolean, string, null, list or a map
/// with string keys), the [toEncodable] function is used to convert it to an
/// object that must be directly encodable.
///
/// If [toEncodable] is omitted, it defaults to a function that returns the
/// result of calling `.toJson()` on the unencodable object.

Map<String, dynamic> todoListToMap(TodoList todoList) {
  Map<String, dynamic> todoListMap = new Map<String, dynamic>();
  todoList.todoList.forEach((todo) {
    // When calling json.encode(), it will automatically call the toJson()
    String todoJson = json.encode(todo);

    todoListMap[todoList.todoList.indexOf(todo).toString()] = todoJson;
  });
  return todoListMap;
}
