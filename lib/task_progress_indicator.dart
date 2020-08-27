import 'package:flutter/material.dart';
import 'package:todo/utils/number_utils.dart';

class TaskProgressIndicator extends StatelessWidget {
  final Color color;
  final progress;

  final _height = 3.0;

  TaskProgressIndicator({@required this.color, @required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(
                    height: _height,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  AnimatedContainer(
                    height: _height,
                    width: (progress / 100) * constraints.maxWidth,
                    color: color,
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "% ${NumberUtils.replaceFarsiNumber(progress.toString())}",
              style: TextStyle(
                fontFamily: 'Anjoman',
                fontSize: 14
              ),
            ),
          ),
        )
      ],
    );
  }
}
