import 'dart:convert';

GetLawyerProfileServiceModel getLawyerProfileServiceModelFromJson(String str) =>
    GetLawyerProfileServiceModel.fromJson(json.decode(str));
String getLawyerProfileServiceModelToJson(GetLawyerProfileServiceModel data) =>
    json.encode(data.toJson());

class GetLawyerProfileServiceModel {
  GetLawyerProfileServiceModel({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetLawyerProfileServiceModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  Data? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetLawyerProfileServiceModel copyWith({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetLawyerProfileServiceModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  Data? get data => _data;
  bool? get success => _success;
  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
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
    List<LawyerProfileServiceModel>? data,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _links = links;
    _meta = meta;
  }

  Data.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LawyerProfileServiceModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<LawyerProfileServiceModel>? _data;
  Links? _links;
  Meta? _meta;
  Data copyWith({
    List<LawyerProfileServiceModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      Data(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<LawyerProfileServiceModel>? get data => _data;
  Links? get links => _links;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());

class Meta {
  Meta({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) {
    _currentPage = currentPage;
    _from = from;
    _lastPage = lastPage;
    _links = links;
    _path = path;
    _perPage = perPage;
    _to = to;
    _total = total;
  }

  Meta.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    _from = json['from'];
    _lastPage = json['last_page'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _path = json['path'];
    _perPage = json['per_page'];
    _to = json['to'];
    _total = json['total'];
  }
  num? _currentPage;
  num? _from;
  num? _lastPage;
  List<Links>? _links;
  String? _path;
  num? _perPage;
  num? _to;
  num? _total;
  Meta copyWith({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) =>
      Meta(
        currentPage: currentPage ?? _currentPage,
        from: from ?? _from,
        lastPage: lastPage ?? _lastPage,
        links: links ?? _links,
        path: path ?? _path,
        perPage: perPage ?? _perPage,
        to: to ?? _to,
        total: total ?? _total,
      );
  num? get currentPage => _currentPage;
  num? get from => _from;
  num? get lastPage => _lastPage;
  List<Links>? get links => _links;
  String? get path => _path;
  num? get perPage => _perPage;
  num? get to => _to;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    map['from'] = _from;
    map['last_page'] = _lastPage;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['path'] = _path;
    map['per_page'] = _perPage;
    map['to'] = _to;
    map['total'] = _total;
    return map;
  }
}

Links linksFromJson(String str) => Links.fromJson(json.decode(str));
String linksToJson(Links data) => json.encode(data.toJson());

class Links {
  Links({
    dynamic url,
    String? label,
    bool? active,
  }) {
    _url = url;
    _label = label;
    _active = active;
  }

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
  Links copyWith({
    dynamic url,
    String? label,
    bool? active,
  }) =>
      Links(
        url: url ?? _url,
        label: label ?? _label,
        active: active ?? _active,
      );
  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }
}

LawyerProfileServiceModel lawyerProfileServiceModelFromJson(String str) =>
    LawyerProfileServiceModel.fromJson(json.decode(str));
String lawyerProfileServiceModelToJson(LawyerProfileServiceModel data) =>
    json.encode(data.toJson());

class LawyerProfileServiceModel {
  LawyerProfileServiceModel({
    num? id,
    Lawyer? lawyer,
    dynamic lawFirm,
    num? serviceCategoryId,
    String? serviceCategoryName,
    List<num>? tagIds,
    List<Tags>? tags,
    List<dynamic>? reviews,
    num? rating,
    num? bookedServicesCount,
    List<dynamic>? faqs,
    String? name,
    NameTranslations? nameTranslations,
    String? description,
    DescriptionTranslations? descriptionTranslations,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    String? image,
    num? price,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _lawyer = lawyer;
    _lawFirm = lawFirm;
    _serviceCategoryId = serviceCategoryId;
    _serviceCategoryName = serviceCategoryName;
    _tagIds = tagIds;
    _tags = tags;
    _reviews = reviews;
    _rating = rating;
    _bookedServicesCount = bookedServicesCount;
    _faqs = faqs;
    _name = name;
    _nameTranslations = nameTranslations;
    _description = description;
    _descriptionTranslations = descriptionTranslations;
    _slug = slug;
    _isActive = isActive;
    _isFeatured = isFeatured;
    _icon = icon;
    _image = image;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  LawyerProfileServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _lawyer = json['lawyer'] != null ? Lawyer.fromJson(json['lawyer']) : null;
    _lawFirm = json['law_firm'];
    _serviceCategoryId = json['service_category_id'];
    _serviceCategoryName = json['service_category_name'];
    _tagIds = json['tag_ids'] != null ? json['tag_ids'].cast<num>() : [];
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(Tags.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        // _reviews?.add(Dynamic.fromJson(v));
      });
    }
    _rating = json['rating'];
    _bookedServicesCount = json['booked_services_count'];
    if (json['faqs'] != null) {
      _faqs = [];
      json['faqs'].forEach((v) {
        // _faqs?.add(Dynamic.fromJson(v));
      });
    }
    _name = json['name'];
    _nameTranslations = json['name_translations'] != null
        ? NameTranslations.fromJson(json['name_translations'])
        : null;
    _description = json['description'];
    _descriptionTranslations = json['description_translations'] != null
        ? DescriptionTranslations.fromJson(json['description_translations'])
        : null;
    _slug = json['slug'];
    _isActive = json['is_active'];
    _isFeatured = json['is_featured'];
    _icon = json['icon'];
    _image = json['image'];
    _price = json['price'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  Lawyer? _lawyer;
  dynamic _lawFirm;
  num? _serviceCategoryId;
  String? _serviceCategoryName;
  List<num>? _tagIds;
  List<Tags>? _tags;
  List<dynamic>? _reviews;
  num? _rating;
  num? _bookedServicesCount;
  List<dynamic>? _faqs;
  String? _name;
  NameTranslations? _nameTranslations;
  String? _description;
  DescriptionTranslations? _descriptionTranslations;
  String? _slug;
  num? _isActive;
  num? _isFeatured;
  dynamic _icon;
  String? _image;
  num? _price;
  String? _createdAt;
  String? _updatedAt;
  LawyerProfileServiceModel copyWith({
    num? id,
    Lawyer? lawyer,
    dynamic lawFirm,
    num? serviceCategoryId,
    String? serviceCategoryName,
    List<num>? tagIds,
    List<Tags>? tags,
    List<dynamic>? reviews,
    num? rating,
    num? bookedServicesCount,
    List<dynamic>? faqs,
    String? name,
    NameTranslations? nameTranslations,
    String? description,
    DescriptionTranslations? descriptionTranslations,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    String? image,
    num? price,
    String? createdAt,
    String? updatedAt,
  }) =>
      LawyerProfileServiceModel(
        id: id ?? _id,
        lawyer: lawyer ?? _lawyer,
        lawFirm: lawFirm ?? _lawFirm,
        serviceCategoryId: serviceCategoryId ?? _serviceCategoryId,
        serviceCategoryName: serviceCategoryName ?? _serviceCategoryName,
        tagIds: tagIds ?? _tagIds,
        tags: tags ?? _tags,
        reviews: reviews ?? _reviews,
        rating: rating ?? _rating,
        bookedServicesCount: bookedServicesCount ?? _bookedServicesCount,
        faqs: faqs ?? _faqs,
        name: name ?? _name,
        nameTranslations: nameTranslations ?? _nameTranslations,
        description: description ?? _description,
        descriptionTranslations:
            descriptionTranslations ?? _descriptionTranslations,
        slug: slug ?? _slug,
        isActive: isActive ?? _isActive,
        isFeatured: isFeatured ?? _isFeatured,
        icon: icon ?? _icon,
        image: image ?? _image,
        price: price ?? _price,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  Lawyer? get lawyer => _lawyer;
  dynamic get lawFirm => _lawFirm;
  num? get serviceCategoryId => _serviceCategoryId;
  String? get serviceCategoryName => _serviceCategoryName;
  List<num>? get tagIds => _tagIds;
  List<Tags>? get tags => _tags;
  List<dynamic>? get reviews => _reviews;
  num? get rating => _rating;
  num? get bookedServicesCount => _bookedServicesCount;
  List<dynamic>? get faqs => _faqs;
  String? get name => _name;
  NameTranslations? get nameTranslations => _nameTranslations;
  String? get description => _description;
  DescriptionTranslations? get descriptionTranslations =>
      _descriptionTranslations;
  String? get slug => _slug;
  num? get isActive => _isActive;
  num? get isFeatured => _isFeatured;
  dynamic get icon => _icon;
  String? get image => _image;
  num? get price => _price;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_lawyer != null) {
      map['lawyer'] = _lawyer?.toJson();
    }
    map['law_firm'] = _lawFirm;
    map['service_category_id'] = _serviceCategoryId;
    map['service_category_name'] = _serviceCategoryName;
    map['tag_ids'] = _tagIds;
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    map['rating'] = _rating;
    map['booked_services_count'] = _bookedServicesCount;
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    map['name'] = _name;
    if (_nameTranslations != null) {
      map['name_translations'] = _nameTranslations?.toJson();
    }
    map['description'] = _description;
    if (_descriptionTranslations != null) {
      map['description_translations'] = _descriptionTranslations?.toJson();
    }
    map['slug'] = _slug;
    map['is_active'] = _isActive;
    map['is_featured'] = _isFeatured;
    map['icon'] = _icon;
    map['image'] = _image;
    map['price'] = _price;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

DescriptionTranslations descriptionTranslationsFromJson(String str) =>
    DescriptionTranslations.fromJson(json.decode(str));
String descriptionTranslationsToJson(DescriptionTranslations data) =>
    json.encode(data.toJson());

class DescriptionTranslations {
  DescriptionTranslations({
    String? en,
    String? hi,
    String? ar,
  }) {
    _en = en;
    _hi = hi;
    _ar = ar;
  }

  DescriptionTranslations.fromJson(dynamic json) {
    _en = json['en'];
    _hi = json['hi'];
    _ar = json['ar'];
  }
  String? _en;
  String? _hi;
  String? _ar;
  DescriptionTranslations copyWith({
    String? en,
    String? hi,
    String? ar,
  }) =>
      DescriptionTranslations(
        en: en ?? _en,
        hi: hi ?? _hi,
        ar: ar ?? _ar,
      );
  String? get en => _en;
  String? get hi => _hi;
  String? get ar => _ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = _en;
    map['hi'] = _hi;
    map['ar'] = _ar;
    return map;
  }
}

NameTranslations nameTranslationsFromJson(String str) =>
    NameTranslations.fromJson(json.decode(str));
String nameTranslationsToJson(NameTranslations data) =>
    json.encode(data.toJson());

class NameTranslations {
  NameTranslations({
    String? en,
    String? hi,
    String? ar,
  }) {
    _en = en;
    _hi = hi;
    _ar = ar;
  }

  NameTranslations.fromJson(dynamic json) {
    _en = json['en'];
    _hi = json['hi'];
    _ar = json['ar'];
  }
  String? _en;
  String? _hi;
  String? _ar;
  NameTranslations copyWith({
    String? en,
    String? hi,
    String? ar,
  }) =>
      NameTranslations(
        en: en ?? _en,
        hi: hi ?? _hi,
        ar: ar ?? _ar,
      );
  String? get en => _en;
  String? get hi => _hi;
  String? get ar => _ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = _en;
    map['hi'] = _hi;
    map['ar'] = _ar;
    return map;
  }
}

Tags tagsFromJson(String str) => Tags.fromJson(json.decode(str));
String tagsToJson(Tags data) => json.encode(data.toJson());

class Tags {
  Tags({
    num? id,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    dynamic image,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _slug = slug;
    _isActive = isActive;
    _isFeatured = isFeatured;
    _icon = icon;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Tags.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _slug = json['slug'];
    _isActive = json['is_active'];
    _isFeatured = json['is_featured'];
    _icon = json['icon'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _name;
  String? _description;
  String? _slug;
  num? _isActive;
  num? _isFeatured;
  dynamic _icon;
  dynamic _image;
  String? _createdAt;
  String? _updatedAt;
  Tags copyWith({
    num? id,
    String? name,
    String? description,
    String? slug,
    num? isActive,
    num? isFeatured,
    dynamic icon,
    dynamic image,
    String? createdAt,
    String? updatedAt,
  }) =>
      Tags(
        id: id ?? _id,
        name: name ?? _name,
        description: description ?? _description,
        slug: slug ?? _slug,
        isActive: isActive ?? _isActive,
        isFeatured: isFeatured ?? _isFeatured,
        icon: icon ?? _icon,
        image: image ?? _image,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get slug => _slug;
  num? get isActive => _isActive;
  num? get isFeatured => _isFeatured;
  dynamic get icon => _icon;
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
    map['is_featured'] = _isFeatured;
    map['icon'] = _icon;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

Lawyer lawyerFromJson(String str) => Lawyer.fromJson(json.decode(str));
String lawyerToJson(Lawyer data) => json.encode(data.toJson());

class Lawyer {
  Lawyer({
    num? id,
    String? name,
    String? image,
    String? description,
    String? userName,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _description = description;
    _userName = userName;
  }

  Lawyer.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _description = json['description'];
    _userName = json['user_name'];
  }
  num? _id;
  String? _name;
  String? _image;
  String? _description;
  String? _userName;
  Lawyer copyWith({
    num? id,
    String? name,
    String? image,
    String? description,
    String? userName,
  }) =>
      Lawyer(
        id: id ?? _id,
        name: name ?? _name,
        image: image ?? _image,
        description: description ?? _description,
        userName: userName ?? _userName,
      );
  num? get id => _id;
  String? get name => _name;
  String? get image => _image;
  String? get description => _description;
  String? get userName => _userName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['description'] = _description;
    map['user_name'] = _userName;
    return map;
  }
}
