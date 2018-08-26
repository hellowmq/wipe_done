/// A basic task
class Todo {
  /// Title of this class
  String title;

  /// Done State of this class
  bool done;

  /// Remark information of this class
  String remark;

  /// Star state of this class
  bool star;

  /// Constructor with [title]

  Todo([String str]) {
    title = str != null ? str : '有个任务';
    remark = "";
    done = false;
    star = false;
  }

  ///  Constructor with [json] String

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        done = json['done'],
        remark = json['remark'],
        star = json['star'];

  ///  Convert an instance to JSON String

  Map<String, dynamic> toJson() => {
        'title': title,
        'done': done,
        'remark': remark,
        'star': star,
      };
}
