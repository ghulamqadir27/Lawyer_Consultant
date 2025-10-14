import 'dart:convert';

GetLawyerServiceCategoriesModel getServiceCategoriesModelFromJson(String str) =>
    GetLawyerServiceCategoriesModel.fromJson(json.decode(str));
String getServiceCategoriesModelToJson(GetLawyerServiceCategoriesModel data) =>
    json.encode(data.toJson());

class GetLawyerServiceCategoriesModel {
  GetLawyerServiceCategoriesModel({
    List<Data>? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetLawyerServiceCategoriesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  List<Data>? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetLawyerServiceCategoriesModel copyWith({
    List<Data>? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetLawyerServiceCategoriesModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  List<Data>? get data => _data;
  bool? get success => _success;
  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['errors'] = _errors;
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    num? id,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    dynamic sortOrder,
    dynamic image,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _slug = slug;
    _isActive = isActive;
    _sortOrder = sortOrder;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _slug = json['slug'];
    _isActive = json['is_active'];
    _sortOrder = json['sort_order'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _name;
  String? _description;
  String? _slug;
  num? _isActive;
  dynamic _sortOrder;
  dynamic _image;
  String? _createdAt;
  String? _updatedAt;
  Data copyWith({
    num? id,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    dynamic sortOrder,
    dynamic image,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        slug: slug ?? _slug,
        isActive: isActive ?? _isActive,
        sortOrder: sortOrder ?? _sortOrder,
        image: image ?? _image,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get slug => _slug;
  num? get isActive => _isActive;
  dynamic get sortOrder => _sortOrder;
  dynamic get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['slug'] = _slug;
    map['is_active'] = _isActive;
    map['sort_order'] = _sortOrder;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
