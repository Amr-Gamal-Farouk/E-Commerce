import 'package:ec_task/util/network_utilities.dart';
import 'package:ec_task/util/url.dart';
import 'model/product_model.dart';
import 'model/response_model.dart';

class ProductService {
  ProductService._();

  static Future<ResponseModel<List<ProductModel>>> getAllProducts() async {
    Map<String, String> requestHeaders = NetworkUtilities.getHeaders(
        customHeaders: {'Content-Type': 'application/json'});

    ResponseModel responseModel = await NetworkUtilities.handleGetRequest(
        methodURL: '${URL.getURL(functionName: URL.kGetAllProducts)}',
        requestHeaders: requestHeaders,
        parserFunction: (listJson) {
          List<ProductModel> productsList = listJson
              .map<ProductModel>(
                  (productJson) => ProductModel.fromJson(productJson))
              .toList();
          return productsList;
        });

    return ResponseModel<List<ProductModel>>(
      responseData: responseModel.responseData,
      isSuccess: responseModel.isSuccess,
      errorModel: responseModel.errorModel,
    );
  }

  static Future<ResponseModel<ProductModel>> getProductDetails(
      {int? productId}) async {
    Map<String, String> requestHeaders = NetworkUtilities.getHeaders(
        customHeaders: {'Content-Type': 'application/json'});

    ResponseModel responseModel = await NetworkUtilities.handleGetRequest(
        methodURL:
            '${URL.getURL(functionName: URL.kGetProductDetails(productId!))}',
        requestHeaders: requestHeaders,
        parserFunction: (productJson) {
          return ProductModel.fromJson(productJson);
        });

    return ResponseModel<ProductModel>(
      responseData: responseModel.responseData,
      isSuccess: responseModel.isSuccess,
      errorModel: responseModel.errorModel,
    );
  }
}
