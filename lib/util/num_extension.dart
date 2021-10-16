import 'package:flutter/material.dart';

extension BorderRadiusExt on num {
  BorderRadius get borderRadius => BorderRadius.circular(this * 1.0);
}
