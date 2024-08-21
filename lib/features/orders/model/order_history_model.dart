
class OrderHistoryModel {
  String? status;
  String? message;
  List<OrderDetails>? details;

  OrderHistoryModel({
    this.status,
    this.message,
    this.details,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    var detailsList = json['details'] as List?;
    List<OrderDetails>? details =
        detailsList?.map((i) => OrderDetails.fromJson(i)).toList();

    return OrderHistoryModel(
      status: json['status'],
      message: json['message'],
      details: details,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details?.map((order) => order.toJson()).toList(),
    };
  }
}

class OrderDetails {
  String? id;
  String? orderNo;
  String? status;
  String? orderTotal;
 
  String? createdAt;
  String? addressId;
  Address? address;
  List<ProductDetails>? products;

  OrderDetails({
    this.id,
    this.orderNo,
    this.status,
    this.orderTotal,
    
    this.createdAt,
    this.addressId,
    this.address,
    this.products,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List?;
    List<ProductDetails>? products =
        productsList?.map((i) => ProductDetails.fromJson(i)).toList();

    return OrderDetails(
      id: json['id'],
      orderNo: json['order_no'],
      status: json['status'],
      orderTotal: json['order_total'],
      
      createdAt: json['created_at'],
      addressId: json['address_id'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'status': status,
      'order_total': orderTotal,
      
      'created_at': createdAt,
      'address_id': addressId,
      'address': address?.toJson(),
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}

class Address {
  String? id;
  String? title;
  String? province;
  String? city;
  String? address;
  String? landmark;

  Address({
    this.id,
    this.title,
    this.province,
    this.city,
    this.address,
    this.landmark,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      title: json['title'],
      province: json['province'],
      city: json['city'],
      address: json['address'],
      landmark: json['landmark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'province': province,
      'city': city,
      'address': address,
      'landmark': landmark,
    };
  }
}

class ProductDetails {
  String? id;
  String? frame;
  String? description;
   String? reviewSubmitted;
  String? frameSize;
  String? frameType;
  String? frameColor;
  String? framePrice;
  String? quantity;
  String? totalPrice;
  List<ProductImage>? images;

  ProductDetails({
    this.id,
    this.frame,
    this.description,
    this.reviewSubmitted,
    this.frameSize,
    this.frameType,
    this.frameColor,
    this.framePrice,
    this.quantity,
    this.totalPrice,
    this.images,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List?;
    List<ProductImage>? images =
        imagesList?.map((i) => ProductImage.fromJson(i)).toList();

    return ProductDetails(
      id: json['id'],
      frame: json['frame'],
      description: json['description'],
      reviewSubmitted: json['review_submitted'],
      frameSize: json['frame_size'],
      frameType: json['frame_type'],
      frameColor: json['frame_color'],
      framePrice: json['frame_price'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frame': frame,
      'description': description,
      'review_submitted': reviewSubmitted,
      'frame_size': frameSize,
      'frame_type': frameType,
      'frame_color': frameColor,
      'frame_price': framePrice,
      'quantity': quantity,
      'total_price': totalPrice,
      'images': images?.map((image) => image.toJson()).toList(),
    };
  }
}

class ProductImage {
  String? id;
  String? imageUrl;

  ProductImage({
    this.id,
    this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imageUrl: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': imageUrl,
    };
  }
}
