import 'package:ec_task/data_provider/model/product_model.dart';
import 'package:ec_task/data_provider/model/response_model.dart';
import 'package:ec_task/data_provider/product_service.dart';

class ProductRepository {
  ProductRepository._();

  static final _instance = ProductRepository._();

  factory ProductRepository() {
    return _instance;
  }

  Future<ResponseModel<List<ProductModel>>> getAllProducts() async =>
      ProductService.getAllProducts();

  Future<ResponseModel<ProductModel>> getProductDetails(
          {int? productId}) async =>
      ProductService.getProductDetails(productId: productId);
}
