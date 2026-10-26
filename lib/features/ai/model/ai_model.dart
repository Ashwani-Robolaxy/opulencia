class AiModel {
  final String? url;
  final int? recordId;

  AiModel({this.url, this.recordId});

  factory AiModel.fromJson(Map<String, dynamic> json) {
    return AiModel(
      url: json['url'],
      recordId: json['record_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'record_id': recordId,
    };
  }
}

// class Data {
//   final Input? input;
//   final Output? output;

//   Data({this.input, this.output});

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       input: json['input'] != null ? Input.fromJson(json['input']) : null,
//       output: json['output'] != null ? Output.fromJson(json['output']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'input': input?.toJson(),
//       'output': output?.toJson(),
//     };
//   }
// }

// class Input {
//   final String? ext;
//   final double? mps;
//   final String? mime;
//   final String? format;
//   final int? width;
//   final int? height;

//   Input({
//     this.ext,
//     this.mps,
//     this.mime,
//     this.format,
//     this.width,
//     this.height,
//   });

//   factory Input.fromJson(Map<String, dynamic> json) {
//     return Input(
//       ext: json['ext'],
//       mps: (json['mps'] != null) ? json['mps'].toDouble() : null,
//       mime: json['mime'],
//       format: json['format'],
//       width: json['width'],
//       height: json['height'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'ext': ext,
//       'mps': mps,
//       'mime': mime,
//       'format': format,
//       'width': width,
//       'height': height,
//     };
//   }
// }

// class Output {
//   final String? ext;
//   final double? mps;
//   final String? mime;
//   final String? format;
//   final int? width;
//   final int? height;
//   final String? tmpUrl;
//   final String objectKey;
//   final String objectBucket;
//   final String objectUri;
//   final String claidStorageUri;

//   Output({
//     this.ext,
//     this.mps,
//     this.mime,
//     this.format,
//     this.width,
//     this.height,
//     this.tmpUrl,
//     this.objectKey = '',
//     this.objectBucket = '',
//     this.objectUri = '',
//     this.claidStorageUri = '',
//   });

//   factory Output.fromJson(Map<String, dynamic> json) {
//     return Output(
//       ext: json['ext'],
//       mps: (json['mps'] != null) ? json['mps'].toDouble() : null,
//       mime: json['mime'],
//       format: json['format'],
//       width: json['width'],
//       height: json['height'],
//       tmpUrl: json['tmp_url'],
//       objectKey: json['object_key'] ?? '',
//       objectBucket: json['object_bucket'] ?? '',
//       objectUri: json['object_uri'] ?? '',
//       claidStorageUri: json['claid_storage_uri'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'ext': ext,
//       'mps': mps,
//       'mime': mime,
//       'format': format,
//       'width': width,
//       'height': height,
//       'tmp_url': tmpUrl,
//       'object_key': objectKey,
//       'object_bucket': objectBucket,
//       'object_uri': objectUri,
//       'claid_storage_uri': claidStorageUri,
//     };
//   }
// }
