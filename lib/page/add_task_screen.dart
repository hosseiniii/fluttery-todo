import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:todo/scopedmodel/todo_list_model.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/component/iconpicker/icon_picker_builder.dart';
import 'package:todo/component/colorpicker/color_picker_builder.dart';
import 'package:todo/utils/color_utils.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen();

  @override
  State<StatefulWidget> createState() {
    return _AddTaskScreenState();
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color taskColor;
  IconData taskIcon;

  @override
  void initState() {
    super.initState();
    setState(() {
      newTask = '';
      taskColor = ColorUtils.defaultColors[0];
      taskIcon = Icons.work;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'دسته‌بندی جدید',
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
                    'دسته‌بندی به شما کمک می‌کند تا کارهای مرتبط را در یک گروه قرار دهید',
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
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
                    cursorColor: taskColor,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'نام دسته ...',
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
                      ColorPickerBuilder(
                          color: taskColor,
                          onColorChanged: (newColor) =>
                              setState(() => taskColor = newColor)),
                      Container(
                        width: 22.0,
                      ),
                      IconPickerBuilder(
                          iconData: taskIcon,
                          highlightColor: taskColor,
                          action: (newIcon) =>
                              setState(() => taskIcon = newIcon)),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
              builder: (BuildContext context) {
                return FloatingActionButton.extended(
                  heroTag: 'fab_new_card',
                  icon: Icon(Icons.save),
                  backgroundColor: taskColor,
                  label: Text('ایجاد دسته',
                    style: TextStyle(
                        fontFamily: 'Anjoman',
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  onPressed: () {
                    if (newTask.isEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          'به نظر می رسد که شما در حال تلاش برای اضافه کردن یک دسته بدون نام هستید که در حال حاضر مجاز نیست.',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Anjoman',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        backgroundColor: taskColor,
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      // _scaffoldKey.currentState.showSnackBar(snackBar);
                    } else {
                      model.addTask(Task(
                        newTask,
                        codePoint: taskIcon.codePoint,
                        color: taskColor.value
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
