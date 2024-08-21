class AddressModel {
  String? status;
  String? message;
  List<AddressDetails>? details;

  AddressModel({
    this.status,
    this.message,
    this.details,
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    return AddressModel(
      status: json?['status'],
      message: json?['message'],
      details: json?['details'] != null
          ? List<AddressDetails>.from((json!['details'] as List<dynamic>?)!
              .map((x) => AddressDetails.fromJson(x as Map<String, dynamic>)))
          : null,
    );
  }
}

class AddressDetails {
  String? id;
  String? title;
  String? province;
  String? city;
  String? address;
  String? landmark;

  AddressDetails({
    this.id,
    this.title,
    this.province,
    this.city,
    this.address,
    this.landmark,
  });

  factory AddressDetails.fromJson(Map<String, dynamic>? json) {
    return AddressDetails(
      id: json?['id'],
      title: json?['title'],
      province: json?['province'],
      city: json?['city'],
      address: json?['address'],
      landmark: json?['landmark'],
    );
  }
}
