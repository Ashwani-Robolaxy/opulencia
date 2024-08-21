class SubProductModel {
  final String? status;
  final String? message;
  final List<SubProductDetail>? details;

  SubProductModel({
    this.status,
    this.message,
    this.details,
  });

  // Factory constructor to create a SubProductModel object from JSON
  factory SubProductModel.fromJson(Map<String, dynamic> json) {
    var detailsJson = json['details'] as List?;
    List<SubProductDetail>? detailsList = detailsJson?.map((detail) => SubProductDetail.fromJson(detail)).toList();

    return SubProductModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      details: detailsList,
    );
  }

  // Method to convert a SubProductModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'details': details?.map((detail) => detail.toJson()).toList(),
    };
  }
}

// SubProductDetail model
class SubProductDetail {
  final String? id;
  final String? categoryId;
  final String? subcategoryId;
  final String? description;
  final double? overallRating;
  final String? frame;
  final List<Image>? images;
  final List<Review>? reviews;
  final List<RatingSummary>? ratingSummary;

  SubProductDetail({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.description,
    this.overallRating,
    this.frame,
    this.images,
    this.reviews,
    this.ratingSummary,
  });

  // Factory constructor to create a SubProductDetail object from JSON
  factory SubProductDetail.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List?;
    List<Image>? imagesList = imagesJson?.map((image) => Image.fromJson(image)).toList();

    var reviewsJson = json['reviews'] as List?;
    List<Review>? reviewsList = reviewsJson?.map((review) => Review.fromJson(review)).toList();

    var ratingSummaryJson = json['rating_summary'] as List?;
    List<RatingSummary>? ratingSummaryList = ratingSummaryJson?.map((rating) => RatingSummary.fromJson(rating)).toList();

    return SubProductDetail(
      id: json['id'] as String?,
      categoryId: json['categoryId'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      description: json['description'] as String?,
      overallRating: (json['overall_rating'] as num?)?.toDouble(),
      frame: json['frame'] as String?,
      images: imagesList,
      reviews: reviewsList,
      ratingSummary: ratingSummaryList,
    );
  }

  // Method to convert a SubProductDetail object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'description': description,
      'overall_rating': overallRating,
      'frame': frame,
      'images': images?.map((image) => image.toJson()).toList(),
      'reviews': reviews?.map((review) => review.toJson()).toList(),
      'rating_summary': ratingSummary?.map((rating) => rating.toJson()).toList(),
    };
  }
}

// Image model
class Image {
  final String? id;
  final String? images;

  Image({
    this.id,
    this.images,
  });

  // Factory constructor to create an Image object from JSON
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'] as String?,
      images: json['images'] as String?,
    );
  }

  // Method to convert an Image object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
    };
  }
}

// Review model
class Review {
  final String? id;
  final String? userId;
  final String? frameId;
  final String? rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;
  final String? firstName;
  final String? lastName;

  Review({
    this.id,
    this.userId,
    this.frameId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
  });

  // Factory constructor to create a Review object from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      frameId: json['frame_id'] as String?,
      rating: json['rating'] as String?,
      review: json['review'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  // Method to convert a Review object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'frame_id': frameId,
      'rating': rating,
      'review': review,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

// RatingSummary model
class RatingSummary {
  final String? rating;
  final String? count;

  RatingSummary({
    this.rating,
    this.count,
  });

  // Factory constructor to create a RatingSummary object from JSON
  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      rating: json['rating'] as String?,
      count: json['count'] as String?,
    );
  }

  // Method to convert a RatingSummary object to JSON
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'count': count,
    };
  }
}
