import 'package:ec_task/bloc/cart_bloc/cart_bloc.dart';
import 'package:ec_task/bloc/product_bloc/product_state.dart';
import 'package:ec_task/util/values/app_colors.dart';
import 'package:ec_task/util/values/strings.dart';
import 'package:ec_task/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = BlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBar(),
      body: BlocConsumer(
        bloc: _cartBloc,
        listener: (context, state) {},
        builder: (context, state) =>
            _cartBloc!.getCart != null || state is LoadingSuccessState
                ? LoadingOverlay(
                    isLoading: state is ProductLoadingState,
                    child: body(list: _cartBloc!.getCart),
                  )
                : LoadingOverlay(
                    isLoading: state is ProductLoadingState,
                    child: Container(),
                  ),
      ),
    );
  }

  appBar() => AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          Strings.kMyCart,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
