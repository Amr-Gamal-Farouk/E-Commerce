
import 'package:ec_task/bloc/product_bloc/product_event.dart';
import 'package:ec_task/data_provider/model/error_model.dart';

abstract class ProductState {}

class ProductLoadingState extends ProductState {}

class LoadingSuccessState extends ProductState {}

class LoadingFailedState extends ProductState {
  final ErrorModel? error;
  final ProductEvent? failedEvent;

  LoadingFailedState({this.error, this.failedEvent});
}
