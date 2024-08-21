import 'package:opulencia/features/category/model/sub_product_model.dart';

class FrameCatModel {
  String status;
  String message;
  List<CategoryDetails> details;

  FrameCatModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory FrameCatModel.fromJson(Map<String, dynamic> json) {
    return FrameCatModel(
      status: json['status'],
      message: json['message'],
      details: List<CategoryDetails>.from(
        json['details'].map((x) => CategoryDetails.fromJson(x)),
      ),
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

class CategoryDetails {
  String id;
  String category;
  String image;
  List<Subcategory> subcategories;

  CategoryDetails({
    required this.id,
    required this.category,
    required this.image,
    required this.subcategories,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      id: json['id'],
      category: json['category'],
      image: json['image'],
      subcategories: List<Subcategory>.from(
        json['subcategories'].map((x) => Subcategory.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'image': image,
      'subcategories': List<dynamic>.from(subcategories.map((x) => x.toJson())),
    };
  }
}

class Subcategory {
  String id;
  String categoryId;
  String subcategory;
  String description;
  String image;
  String created;
  List<SubProductDetail> frames;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.subcategory,
    required this.description,
    required this.image,
    required this.created,
    required this.frames,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      categoryId: json['categoryId'],
      subcategory: json['subcategory'],
      description: json['description'],
      image: json['image'],
      created: json['created'],
      frames: List<SubProductDetail>.from(
        json['frames'].map((x) => SubProductDetail.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'subcategory': subcategory,
      'description': description,
      'image': image,
      'created': created,
      'frames': List<dynamic>.from(frames.map((x) => x.toJson())),
    };
  }
}

// class Frame {
//   String id;
//   String frame;
//   String description;
//   String created;

//   List<Image> images;

//   Frame({
//     required this.id,
//     required this.frame,
//     required this.description,
//     required this.created,

//     required this.images,
//   });

//   factory Frame.fromJson(Map<String, dynamic> json) {
//     return Frame(
//       id: json['id'],
//       frame: json['frame'],
//       description: json['description'],
//       created: json['created'],

//       images: List<Image>.from(
//         json['images'].map((x) => Image.fromJson(x)),
//       ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'frame': frame,
//       'description': description,
//       'created': created,

//       'images': List<dynamic>.from(images.map((x) => x.toJson())),
//     };
//   }
// }

class Image {
  String id;
  String images;

  Image({
    required this.id,
    required this.images,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
    };
  }
}
