import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:todo/scopedmodel/todo_list_model.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/color_utils.dart';
import 'package:todo/component/todo_badge.dart';
import 'package:todo/model/hero_id_model.dart';

class AddTodoScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  AddTodoScreen({
    @required this.taskId,
    @required this.heroIds,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddTodoScreenState();
  }
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        if (model.tasks.isEmpty) {
          // Loading
          return Container(
            color: Colors.white,
          );
        }

        var _task = model.tasks.firstWhere((it) => it.id == widget.taskId);
        var _color = ColorUtils.getColorFrom(id: _task.color);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'کار جدید',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Anjoman',
                    fontWeight: FontWeight.w700
                ),
              ),
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black26),
              brightness: Brightness.light,
              backgroundColor: Colors.white,
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قصد انجام چه کاری دارید؟',
                    style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16.0,
                        fontFamily: 'Anjoman'
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() => newTask = text);
                    },
                    cursorColor: _color,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'نام فعالیت ...',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                        )),
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 36.0,
                        fontFamily: 'Anjoman'
                    ),
                  ),
                  Container(
                    height: 26.0,
                  ),
                  Row(
                    children: [
                      TodoBadge(
                        codePoint: _task.codePoint,
                        color: _color,
                        id: widget.heroIds.codePointId,
                        size: 20.0,
                      ),
                      Container(
                        width: 16.0,
                      ),
                      Hero(
                        child: Text(
                          _task.name,
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Anjoman'
                          ),
                        ),
                        tag: "not_using_right_now", //widget.heroIds.titleId,
                      ),
                    ],
                  )
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (BuildContext context) {
                return FloatingActionButton.extended(
                  heroTag: 'fab_new_task',
                  icon: Icon(Icons.add),
                  backgroundColor: _color,
                  label: Text(
                      'ایجاد کار',
                  style: TextStyle(
                    fontFamily: 'Anjoman',
                    fontWeight: FontWeight.w700
                  ),
                  ),
                  onPressed: () {
                    if (newTask.isEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                            'به نظر می رسد که شما در حال تلاش برای اضافه کردن یک فعالیت خالی هستید که در حال حاضر مجاز نیست.',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Anjoman',
                              fontWeight: FontWeight.w300,
                            ),
                        ),
                        backgroundColor: _color,
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      // _scaffoldKey.currentState.showSnackBar(snackBar);
                    } else {
                      model.addTodo(Todo(
                        newTask,
                        parent: _task.id,
                      ));
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
