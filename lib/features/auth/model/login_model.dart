class LoginModel {
  final String status;
  final String message;
  final LoginDetails details;

  LoginModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      message: json['message'],
      details: LoginDetails.fromJson(json['details']),
    );
  }
}

class LoginDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String created;
  final String authToken;

  LoginDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.created,
    required this.authToken,
  });

  factory LoginDetails.fromJson(Map<String, dynamic> json) {
    return LoginDetails(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      created: json['created'],
      authToken: json['auth_token'],
    );
  }
}
