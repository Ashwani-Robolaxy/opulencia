import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel extends HiveObject {
  @HiveField(0)
  String frameId;

  @HiveField(1)
  String priceId;

  @HiveField(2)
  String frameColor;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  String name;

  @HiveField(5)
  String price;

  @HiveField(6)
  bool isBordered;

  @HiveField(7)
  String selectedSize;

  @HiveField(8)
  String image;

  @HiveField(9)  // New field index for discountApplicable
  String discountApplicable;

  @HiveField(10)  // New field index for discountPercentage
  String discountPercentage;

  OrderModel({
    required this.frameId,
    required this.priceId,
    required this.frameColor,
    required this.quantity,
    required this.name,
    required this.price,
    required this.isBordered,
    required this.selectedSize,
    required this.image,
    required this.discountApplicable,  // Add this line
    required this.discountPercentage,  // Add this line
  });
}
