class BannerModel {
  String status;
  String message;
  List<BannerDetail> details;

  BannerModel(
      {required this.status, required this.message, required this.details});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      status: json['status'],
      message: json['message'],
      details: (json['details'] as List)
          .map((i) => BannerDetail.fromJson(i))
          .toList(),
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
  String bannerTitle;
  String categoryId;
  String subcategoryId;
  String discount;

  BannerDetail({
    required this.id,
    required this.remove,
    required this.banner,
    required this.createdAt,
    required this.bannerTitle,
    required this.categoryId,
    required this.subcategoryId,
    required this.discount,
  });

  factory BannerDetail.fromJson(Map<String, dynamic> json) {
    return BannerDetail(
      id: json['id'],
      remove: json['remove'],
      banner: json['banner'],
      createdAt: json['created_at'],
      bannerTitle: json['banner_title'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remove': remove,
      'banner': banner,
      'created_at': createdAt,
      'banner_title': bannerTitle,
      'category_id': categoryId,
      'subcategoryId': subcategoryId,
      'discount': discount,
    };
  }
}
