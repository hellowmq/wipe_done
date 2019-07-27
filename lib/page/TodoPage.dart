import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wipe_done_new/todo/Todo.dart';

class TodoPage extends StatefulWidget {
  final Todo todo;

  TodoPage({Key key, @required this.todo}) : super(key: key);
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = new TextEditingController(
      text: widget.todo.remark,
    );
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.todo.title),
        centerTitle: true,
        actions: <Widget>[
          new FlatButton(
            child: Text(
              "分享",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                Share.share('任务：${widget.todo.title}'
                    '${widget.todo.remark == '' ? ('\n' + widget.todo.remark) : ''}');
              });
            },
          ),
        ],
      ),
      body: new ListView(
        padding: EdgeInsets.only(top: 6.0),
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(
              8.0,
              4.0,
              8.0,
              4.0,
            ),
            child: new Card(
              child: new ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var textController = new TextEditingController(
                        text: widget.todo.title,
                      );
                      return new AlertDialog(
                        title: Text("新建任务"),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              new Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                child: new TextField(
                                  onSubmitted: (text) {
                                    setState(() {
                                      widget.todo.title = text;
                                    });
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
                              setState(() {
                                widget.todo.title = textController.text;
                              });
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
                },
                contentPadding: const EdgeInsets.fromLTRB(
                  4.0,
                  8.0,
                  4.0,
                  8.0,
                ),
                title: new Text(
                  widget.todo.title,
                  style: widget.todo.done
                      ? TextStyle(decoration: TextDecoration.lineThrough)
                      : TextStyle(),
                ),
                leading: new IconButton(
                  icon: Icon(
                    widget.todo.done
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.todo.done = !widget.todo.done;
                    });
                  },
                ),
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(
              8.0,
              4.0,
              8.0,
              4.0,
            ),
            child: new Card(
              child: new ListTile(
                contentPadding: const EdgeInsets.fromLTRB(
                  4.0,
                  8.0,
                  4.0,
                  8.0,
                ),
                title: const Text(
                  "设为星标任务",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                leading: new IconButton(
                  icon: widget.todo.star
                      ? Icon(
                          Icons.star,
                          color: Colors.amber,
                        )
                      : Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                  onPressed: () {
                    setState(() {
                      widget.todo.star = !widget.todo.star;
                    });
                  },
                ),
              ),
            ),
          ),
//          new Divider(),
          new Padding(
            padding: const EdgeInsets.fromLTRB(
              8.0,
              4.0,
              8.0,
              4.0,
            ),
            child: new Card(
              child: Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(
                          18.0,
                          8.0,
                          8.0,
                          0.0,
                        ),
                        child: new Text(
                          "备注",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w200,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Divider(),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(
                      18.0,
                      8.0,
                      18.0,
                      8.0,
                    ),
                    child: new TextField(
                      onChanged: (text) {
                        widget.todo.remark = textEditingController.text;
                      },
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      controller: textEditingController,
                      maxLines: 6,
                      decoration: InputDecoration(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
