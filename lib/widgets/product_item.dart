import 'package:ec_task/bloc/cart_bloc/cart_bloc.dart';
import 'package:ec_task/data_provider/model/product_model.dart';
import 'package:ec_task/screens/product_details.dart';
import 'package:ec_task/util/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItem extends StatelessWidget {
  final ProductModel? productModel;
  final CartBloc? bloc;

  ProductItem({this.productModel, this.bloc});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        orientation: Orientation.portrait);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: bloc!,
          child: ProductDetails(
            product: productModel,
          ),
        ),
      )),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTitle(productModel!.title!),
                            style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                          ),
                          Text(
                            productModel!.category!,
                            style: TextStyle(
                                color: AppColors.grey,
                                fontSize: ScreenUtil().setSp(14)),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.ios_share,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "\$${productModel!.price!}",
                            style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                height: 140,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey,
                    offset: Offset(-2, -15),
                  ),
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey,
                    offset: Offset(-2, 15),
                  ),
                  BoxShadow(blurRadius: 15, color: Colors.grey),
                  BoxShadow(color: Colors.white, offset: Offset(0, -16)),
                  BoxShadow(color: Colors.white, offset: Offset(0, 16)),
                  BoxShadow(color: Colors.white, offset: Offset(16, -16)),
                  BoxShadow(color: Colors.white, offset: Offset(16, 16)),
                ],
              ),
              child: SizedBox(
                width: 150,
                height: 100,
                child: Image.network(
                  productModel!.image!,
                  fit: BoxFit.contain,
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
            ),
          ],
        ),
      ),
    );
  }

  String getTitle(String title) {
    if (title.length > 70) {
      return "${title.substring(0, 70)}...";
    } else
      return title;
  }
}
