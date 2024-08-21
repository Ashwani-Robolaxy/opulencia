class BannerModel {
  String status;
  String message;
  List<BannerDetail> details;

  BannerModel({required this.status, required this.message, required this.details});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      status: json['status'],
      message: json['message'],
      details: (json['details'] as List).map((i) => BannerDetail.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class BannerDetail {
  String id;
  String remove;
  String banner;
  String createdAt;

  BannerDetail({required this.id, required this.remove, required this.banner, required this.createdAt});

  factory BannerDetail.fromJson(Map<String, dynamic> json) {
    return BannerDetail(
      id: json['id'],
      remove: json['remove'],
      banner: json['banner'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remove': remove,
      'banner': banner,
      'created_at': createdAt,
    };
  }
}
