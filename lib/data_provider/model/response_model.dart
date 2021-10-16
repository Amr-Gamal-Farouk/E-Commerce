import 'error_model.dart';

class ResponseModel<T> {
  T? responseData;
  ErrorModel? errorModel;
  bool? isSuccess;
  int? paginationPageSize;

  ResponseModel(
      {this.responseData,
      this.paginationPageSize,
      this.errorModel,
      this.isSuccess});

  @override
  String toString() {
    return 'ResponseModel{responseData: $responseData, errorModel: $errorModel, isSuccess: $isSuccess, paginationPageSize: $paginationPageSize}';
  }
}
