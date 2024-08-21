class CommonModel {
  final String status;
  final String message;
  final String details;

  CommonModel({
    required this.status,
    required this.message,
    required this.details,
  });

  // Factory method to create an instance from a JSON map
  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      status: json['status'] as String,
      message: json['message'] as String,
      details: json['details'] as String,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details,
    };
  }
}
