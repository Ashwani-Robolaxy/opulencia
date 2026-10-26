class AiOrderModel {
  final String status;
  final String message;
  final List<AiOrderDetail> details;

  AiOrderModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory AiOrderModel.fromJson(Map<String, dynamic> json) {
    return AiOrderModel(
      status: json['status'] as String,
      message: json['message'] as String,
      details: (json['details'] as List)
          .map((order) => AiOrderDetail.fromJson(order))
          .toList(),
    );
  }
}

class AiOrderDetail {
  final String id;
  final String ogImage;
  final String enhancedImage;
  final String status;
  final String frameType;
  final String frameColor;
  final String orderNo;
  final String frameSize;
  final String orderTotal;
  final String addressId;
  final Address address;

  AiOrderDetail({
    required this.id,
    required this.ogImage,
    required this.enhancedImage,
    required this.status,
    required this.frameType,
    required this.frameColor,
    required this.orderNo,
    required this.frameSize,
    required this.orderTotal,
    required this.addressId,
    required this.address,
  });

  factory AiOrderDetail.fromJson(Map<String, dynamic> json) {
    return AiOrderDetail(
      id: json['id'] as String,
      ogImage: json['og_image'] as String,
      enhancedImage: json['enhanced_image'] as String,
      status: json['status'] as String,
      frameType: json['frame_type'] as String,
      frameColor: json['frame_color'] as String,
      orderNo: json['order_no'] as String,
      frameSize: json['frame_size'] as String,
      orderTotal: json['order_total'] as String,
      addressId: json['address_id'] as String,
      address: Address.fromJson(json['address']),
    );
  }
}

class Address {
  final String id;
  final String userId;
  final String title;
  final String province;
  final String city;
  final String address;
  final String landmark;
  final String created;

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
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      landmark: json['landmark'] as String,
      created: json['created'] as String,
    );
  }
}
