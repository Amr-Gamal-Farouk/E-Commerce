import 'package:ec_task/bloc/product_bloc/product_event.dart';
import 'package:ec_task/bloc/product_bloc/product_state.dart';
import 'package:ec_task/data_provider/model/product_model.dart';
import 'package:ec_task/data_provider/model/response_model.dart';
import 'package:ec_task/repository/product_repository.dart';
import 'package:ec_task/util/network_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository? repository;

  ProductBloc() : super(ProductLoadingState()) {
    repository = ProductRepository();
  }

  List<ProductModel>? productList;

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    bool isUserConnected = await NetworkUtilities.isConnected();
    if (isUserConnected == false) {
      yield LoadingFailedState(
        failedEvent: event,
        error: kConnectionTimeOutError,
      );
      return;
    }
    yield ProductLoadingState();
    if (event is LoadProducts) {
      yield* _handleLoadProducts(event);
    } else if (event is LoadProductDetails) {}
  }

  Stream<ProductState> _handleLoadProducts(LoadProducts event) async* {
    ResponseModel<List<ProductModel>> productsResponseModel =
        await repository!.getAllProducts();
    if (productsResponseModel.isSuccess!) {
      productList = List.empty(growable: true);
      productList!.addAll(productsResponseModel.responseData!);

      yield LoadingSuccessState();
    } else {
      yield LoadingFailedState(
        error: productsResponseModel.errorModel!,
        failedEvent: event,
      );
    }
  }
}
