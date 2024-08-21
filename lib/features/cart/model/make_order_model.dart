
import 'package:opulencia/features/cart/model/order_model.dart';

class Product {
  String frameId;
  String priceId;
  String frameColor;
  String quantity;

  Product({
    required this.frameId,
    required this.priceId,
    required this.frameColor,
    required this.quantity,
  });

  factory Product.fromOrderModel(OrderModel order) {
    return Product(
      frameId: order.frameId,
      priceId: order.priceId,
      frameColor: order.frameColor,
      quantity: order.quantity.toString(),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      frameId: json['frame_id'],
      priceId: json['price_id'],
      frameColor: json['frame_color'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frame_id': frameId,
      'price_id': priceId,
      'frame_color': frameColor,
      'quantity': quantity,
    };
  }
}

class MakeOrderModel {
  String addressId;
  String totalPrice;
  List<Product> products;

  MakeOrderModel({
    required this.addressId,
    required this.totalPrice,
    required this.products,
  });

  factory MakeOrderModel.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> products = productList.map((i) => Product.fromJson(i)).toList();

    return MakeOrderModel(
      addressId: json['address_id'],
      totalPrice: json['total_price'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'total_price': totalPrice,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}