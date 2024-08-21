class CustomOrderModel {
  String status;
  String message;
  List<CustomOrderList> details;

  CustomOrderModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory CustomOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomOrderModel(
      status: json['status'],
      message: json['message'],
      details: List<CustomOrderList>.from(
          json['details'].map((x) => CustomOrderList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': List<dynamic>.from(details.map((x) => x.toJson())),
    };
  }
}

class CustomOrderList {
  String id;
  String orderNo;
  String type;
  String status;
  String orderTotal;
  String createdAt;
  String addressId;
  Address address;
  CustomOrderDetail details;

  CustomOrderList({
    required this.id,
    required this.orderNo,
    required this.type,
    required this.status,
    required this.orderTotal,
    required this.createdAt,
    required this.addressId,
    required this.address,
    required this.details,
  });

  factory CustomOrderList.fromJson(Map<String, dynamic> json) {
    return CustomOrderList(
      id: json['id'],
      orderNo: json['order_no'],
      type: json['type'],
      status: json['status'],
      orderTotal: json['order_total'],
      createdAt: json['created_at'],
      addressId: json['address_id'],
      address: Address.fromJson(json['address']),
      details: CustomOrderDetail.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'type': type,
      'status': status,
      'order_total': orderTotal,
      'created_at': createdAt,
      'address_id': addressId,
      'address': address.toJson(),
      'details': details.toJson(),
    };
  }
}

class Address {
  String id;
  String userId;
  String title;
  String province;
  String city;
  String address;
  String landmark;
  String created;

  Address({
    required this.id,
    required this.userId,
    required this.title,
    required this.province,
    required this.city,
    required this.address,
    required this.landmark,
    required this.created,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      province: json['province'],
      city: json['city'],
      address: json['address'],
      landmark: json['landmark'],
      created: json['created'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'province': province,
      'city': city,
      'address': address,
      'landmark': landmark,
      'created': created,
    };
  }
}

class CustomOrderDetail {
  String id;
  String orderId;
  String type;
  String frameImage;
  String frameType;
  String frameColor;
  String frameSize;
  String price;
  String customDetails;
  String createdAt;
  String updatedAt;

  CustomOrderDetail({
    required this.id,
    required this.orderId,
    required this.type,
    required this.frameImage,
    required this.frameType,
    required this.frameColor,
    required this.frameSize,
    required this.price,
    required this.customDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomOrderDetail.fromJson(Map<String, dynamic> json) {
    return CustomOrderDetail(
      id: json['id'],
      orderId: json['order_id'],
      type: json['type'],
      frameImage: json['frame_image'],
      frameType: json['frame_type'],
      frameColor: json['frame_color'],
      frameSize: json['frame_size'],
      price: json['price'],
      customDetails: json['custom_details'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'type': type,
      'frame_image': frameImage,
      'frame_type': frameType,
      'frame_color': frameColor,
      'frame_size': frameSize,
      'price': price,
      'custom_details': customDetails,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
