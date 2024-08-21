class PriceModel {
  final String status;
  final String message;
  final List<PriceDetails> details;

  PriceModel({
    required this.status,
    required this.message,
    required this.details,
  });

  // Factory constructor to create a PriceModel object from JSON
  factory PriceModel.fromJson(Map<String, dynamic> json) {
    var detailsJson = json['details'] as List;
    List<PriceDetails> detailsList =
        detailsJson.map((detail) => PriceDetails.fromJson(detail)).toList();

    return PriceModel(
      status: json['status'] as String,
      message: json['message'] as String,
      details: detailsList,
    );
  }

  // Method to convert a PriceModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}

class PriceDetails {
  final String id;
  final String size;
  final String type;
  final String supplierPrice;
  final String gain;
  final String endPrice;
  final String created;

  PriceDetails({
    required this.id,
    required this.size,
    required this.type,
    required this.supplierPrice,
    required this.gain,
    required this.endPrice,
    required this.created,
  });

  // Factory constructor to create a PriceDetails object from JSON
  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      id: json['id'] as String,
      size: json['size'] as String,
      type: json['type'] as String,
      supplierPrice: json['supplier_price'] as String,
      gain: json['gain'] as String,
      endPrice: json['end_price'] as String,
      created: json['created'] as String,
    );
  }

  // Method to convert a PriceDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'type': type,
      'supplier_price': supplierPrice,
      'gain': gain,
      'end_price': endPrice,
      'created': created,
    };
  }
}
