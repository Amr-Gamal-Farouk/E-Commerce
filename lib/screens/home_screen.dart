import 'package:ec_task/bloc/cart_bloc/cart_bloc.dart';
import 'package:ec_task/bloc/cart_bloc/cart_event.dart';
import 'package:ec_task/bloc/product_bloc/product_bloc.dart';
import 'package:ec_task/bloc/product_bloc/product_event.dart';
import 'package:ec_task/bloc/product_bloc/product_state.dart';
import 'package:ec_task/screens/cart_screen.dart';
import 'package:ec_task/util/values/app_colors.dart';
import 'package:ec_task/util/values/strings.dart';
import 'package:ec_task/widgets/badged_icon.dart';
import 'package:ec_task/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductBloc _bloc = ProductBloc();
  CartBloc _cartBloc = CartBloc();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await GetStorage.init();
    _cartBloc.add(LoadCart());
    _bloc.add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBar(),
      body: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {},
        builder: (context, state) =>
            state is LoadingSuccessState || _bloc.productList != null
                ? LoadingOverlay(
                    isLoading: state is ProductLoadingState,
                    child: body(list: _bloc.productList!),
                  )
                : LoadingOverlay(
                    isLoading: state is ProductLoadingState,
                    child: Container(),
                  ),
      ),
    );
  }

  appBar() => AppBar(
        title: Text(
          Strings.kListingTitle,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          StreamBuilder(
            stream: _cartBloc.cartItemsStream,
            builder: (context, snapshot) => BadgedIcon(
              count: _cartBloc.cartLength,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: _cartBloc,
                    child: CartScreen(),
                  ),
                )),
              ),
            ),
          ),
        ],
      );

  body({list}) => list.length > 0
      ? ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) => ProductItem(
                bloc: _cartBloc,
                productModel: list[index],
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: 20,
              ),
          itemCount: list.length)
      : Container(
          child: Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        );
}
