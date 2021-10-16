import 'package:flutter/material.dart';

extension HexColorExt on String {

  Color get fromHex {
    final buffer = StringBuffer();
    if (this.length == 6 || this.length == 7) {
      buffer.write('ff');
    }

    if (this.startsWith('#')) {
      buffer.write(this.replaceFirst('#', ''));
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
