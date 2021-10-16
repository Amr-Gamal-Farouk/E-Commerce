import 'package:ec_task/util/api_parse_keys.dart';

class ProductModel {
  int? id;
  double? price;
  String? title, description, category, image;

  ProductModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image});

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    return ProductModel(
      id: json![ApiParseKeys.kID]!,
      title: json[ApiParseKeys.kTitle]!,
      price: json[ApiParseKeys.kPrice]! * 1.0,
      description: json[ApiParseKeys.kDescription]!,
      category: json[ApiParseKeys.kCategory]!,
      image: json[ApiParseKeys.kImage]!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiParseKeys.kID: this.id!,
      ApiParseKeys.kTitle: this.title!,
      ApiParseKeys.kPrice: this.price!,
      ApiParseKeys.kDescription: this.description!,
      ApiParseKeys.kCategory: this.category!,
      ApiParseKeys.kImage: this.image!,
    };
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, title: $title, price: $price, description: $description, category: $category, image: $image}';
  }
}
