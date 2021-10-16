import 'package:ec_task/data_provider/model/product_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class ClearCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final ProductModel productModel;

  AddProductToCart({required this.productModel});
}
