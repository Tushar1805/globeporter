class VehicleTypeResponseModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final List<Data?>? data;

  VehicleTypeResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  VehicleTypeResponseModel.fromJson(final Map<String, dynamic>? json)
      : status = json?['status'] as bool?,
        statusCode = json?['status_code'] as int?,
        message = json?['message'] as String?,
        data = (json?['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'data': data?.map((e) => e?.toJson()).toList()
      };
}

class Data {
  final int? id;
  final String? name;
  final String? image;
  final int? status;
  final String? imageUrl;

  Data({
    this.id,
    this.name,
    this.image,
    this.status,
    this.imageUrl,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?,
        status = json['status'] as int?,
        imageUrl = json['image_url'] as String?;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'image': image, 'status': status, 'image_url': imageUrl};
}
