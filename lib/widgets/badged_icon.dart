import 'package:ec_task/util/values/app_colors.dart';
import 'package:flutter/material.dart';

class BadgedIcon extends StatelessWidget {
  int? count;
  Widget? child;

  BadgedIcon({this.count, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child!,
        if (count != null && count! > 0)
          Positioned(
            right: 10,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '${count!}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
