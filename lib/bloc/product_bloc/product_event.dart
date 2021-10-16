abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final int id;

  LoadProductDetails({required this.id});
}
