import 'package:ec_task/data_provider/model/product_model.dart';
import 'package:ec_task/util/network_utilities.dart';
import 'package:ec_task/util/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState());

  List<ProductModel> _userCart = List.empty(growable: true);

  BehaviorSubject<bool> _cartHasItems = BehaviorSubject<bool>();

  Stream<bool> get cartItemsStream => _cartHasItems.stream;

  Function(bool) get cartHasItemsSink => _cartHasItems.sink.add;

  int get cartLength => _userCart.length;

  List<ProductModel> get getCart => _userCart;

  final _kCartKey = 'cart';

  bool isCartItem(ProductModel product) {
    for (int i = 0; i < _userCart.length; i++) {
      if (product.id == _userCart[i].id) {
        return true;
      }
    }
    return false;
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    bool isConnected = await NetworkUtilities.isConnected();
    if (isConnected == false) {
      yield CartLoadingFailedState(
        error: kConnectionTimeOutError,
        failedEvent: event,
      );
      return;
    }
    if (event is LoadCart) {
      yield* _handleCartLoading(event);
    } else if (event is AddProductToCart) {
      yield* _handleAddProductToCart(event);
    } else if (event is ClearCart) {
      yield* clearCart(event);
    }
  }

  Stream<CartState> _handleCartLoading(LoadCart event) async* {
    yield CartLoadingState();
    if (Storage.hasData(_kCartKey)) {
      _userCart.clear();
      List list = await Storage.getValue(_kCartKey)!;
      list.forEach((element) {
        _userCart.add(ProductModel.fromJson(element));
      });
    }
    cartHasItemsSink(true);
    yield CartLoadingSuccessState();
  }

  Stream<CartState> _handleAddProductToCart(AddProductToCart event) async* {
    yield CartLoadingState();
    print(Storage.hasData(_kCartKey));
    if (Storage.hasData(_kCartKey)) {
      if (_userCart.length == 0) {
        List list = await Storage.getValue(_kCartKey)!;
        list.forEach((element) {
          _userCart.add(ProductModel.fromJson(element));
        });
      }
      _userCart.add(event.productModel);
      await Storage.saveValue(_kCartKey, _userCart);
    } else {
      _userCart.add(event.productModel);
      await Storage.saveValue(_kCartKey, _userCart);
    }
    cartHasItemsSink(true);
    yield CartLoadingSuccessState();
  }

  Stream<CartState> clearCart(ClearCart event) async* {
    if (Storage.hasData(_kCartKey)) {
      _userCart.clear();
      await Storage.removeValue(_kCartKey);
    }
    cartHasItemsSink(false);
    yield CartLoadingSuccessState();
  }
}
