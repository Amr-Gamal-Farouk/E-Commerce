class URL {
  static const String BASE_URL = "https://fakestoreapi.com/";

  //-------------------------- API endpoints ---------------------------------
  static const String kGetAllProducts = 'products';

  static String kGetProductDetails(id) => kGetAllProducts + '/$id';

  static String getURL({String? functionName}) {
    return BASE_URL + functionName!;
  }
}
