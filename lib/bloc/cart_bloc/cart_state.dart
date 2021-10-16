

import 'package:ec_task/bloc/cart_bloc/cart_event.dart';
import 'package:ec_task/data_provider/model/error_model.dart';

abstract class CartState {}

class CartLoadingState extends CartState {}

class CartLoadingSuccessState extends CartState {}

class CartLoadingFailedState extends CartState {
  final ErrorModel? error;
  final CartEvent? failedEvent;

  CartLoadingFailedState({this.error, this.failedEvent});
}
