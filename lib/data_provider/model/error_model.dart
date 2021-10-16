import 'package:flutter/foundation.dart';

class ErrorModel {
  int? errorCode;
  String? errorMessage;

  ErrorModel({@required this.errorCode, @required this.errorMessage});

  @override
  String toString() {
    return 'ErrorModel{errorCode: $errorCode, errorMessage: $errorMessage}';
  }
}
