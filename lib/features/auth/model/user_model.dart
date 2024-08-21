class UserModel {
  final String? status;
  final String? message;
  final UserDetails? details;

  UserModel({
    this.status,
    this.message,
    this.details,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'],
      message: json['message'],
      details: json['details'] != null
          ? UserDetails.fromJson(json['details'])
          : null,
    );
  }
}

class UserDetails {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? created;
  final String? accountId;

  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.created,
    this.accountId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      created: json['created'],
      accountId: json['account_id'],
    );
  }
}
