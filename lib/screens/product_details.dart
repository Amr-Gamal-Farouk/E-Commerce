import 'package:ec_task/bloc/cart_bloc/cart_bloc.dart';
import 'package:ec_task/bloc/cart_bloc/cart_event.dart';
import 'package:ec_task/data_provider/model/product_model.dart';
import 'package:ec_task/util/num_extension.dart';
import 'package:ec_task/util/values/app_colors.dart';
import 'package:ec_task/util/values/strings.dart';
import 'package:ec_task/widgets/badged_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cart_screen.dart';

class ProductDetails extends StatefulWidget {
  ProductModel? product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  CartBloc? _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = BlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBar(),
      body: body(),
    );
  }

  appBar() => AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          Strings.kDetailsTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder(
            stream: _cartBloc!.cartItemsStream,
            builder: (context, snapshot) => BadgedIcon(
              count: _cartBloc!.cartLength,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: _cartBloc!,
                      child: CartScreen(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  body() => Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: ScreenUtil().setWidth(270)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product!.title!,
                          style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                        ),
                        Text(
                          widget.product!.category!,
                          style: TextStyle(
                              color: AppColors.grey,
                              fontSize: ScreenUtil().setSp(15)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "\$${widget.product!.price!}",
                    style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Image(
                  image: NetworkImage(
                    widget.product!.image!,
                  ),
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(300),
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.all(10.0).add(EdgeInsets.only(bottom: 15.0)),
                child: Text(
                  widget.product!.description!,
                  style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    new BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ]),
                  child: ButtonTheme(
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        _cartBloc!.add(
                            AddProductToCart(productModel: widget.product!));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: 30.borderRadius,
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.accentColor,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 10,
                          ),
                          child: Text(
                            Strings.kAddToCart,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  String getTitle(String title) {
    if (title.length > 30) {
      return "${title.substring(0, 30)}...";
    } else
      return title;
  }
}
