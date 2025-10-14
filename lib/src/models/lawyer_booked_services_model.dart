import 'dart:convert';

GetLawyerBookedServicesModel getLawyerBookedServicesModelFromJson(String str) =>
    GetLawyerBookedServicesModel.fromJson(json.decode(str));
String getLawyerBookedServicesModelToJson(GetLawyerBookedServicesModel data) =>
    json.encode(data.toJson());

class GetLawyerBookedServicesModel {
  GetLawyerBookedServicesModel({
    GetLawyerBookedServicesDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetLawyerBookedServicesModel.fromJson(dynamic json) {
    _data = json['data'] != null
        ? GetLawyerBookedServicesDataModel.fromJson(json['data'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  GetLawyerBookedServicesDataModel? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetLawyerBookedServicesModel copyWith({
    GetLawyerBookedServicesDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetLawyerBookedServicesModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  GetLawyerBookedServicesDataModel? get data => _data;
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

GetLawyerBookedServicesDataModel getLawyerBookedServicesDataModelFromJson(
        String str) =>
    GetLawyerBookedServicesDataModel.fromJson(json.decode(str));
String getLawyerBookedServicesDataModelToJson(
        GetLawyerBookedServicesDataModel getLawyerBookedServicesDataModel) =>
    json.encode(getLawyerBookedServicesDataModel.toJson());

class GetLawyerBookedServicesDataModel {
  GetLawyerBookedServicesDataModel({
    List<LawyerBookedServiceModel>? data,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _links = links;
    _meta = meta;
  }

  GetLawyerBookedServicesDataModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LawyerBookedServiceModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<LawyerBookedServiceModel>? _data;
  Links? _links;
  Meta? _meta;
  GetLawyerBookedServicesDataModel copyWith({
    List<LawyerBookedServiceModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      GetLawyerBookedServicesDataModel(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<LawyerBookedServiceModel>? get data => _data;
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

LawyerBookedServiceModel dataFromJson(String str) =>
    LawyerBookedServiceModel.fromJson(json.decode(str));
String dataToJson(LawyerBookedServiceModel data) => json.encode(data.toJson());

class LawyerBookedServiceModel {
  LawyerBookedServiceModel({
    num? id,
    num? customerId,
    String? customerName,
    String? customerImage,
    num? lawyerId,
    String? lawyerName,
    String? lawyerImage,
    dynamic lawFirmId,
    dynamic lawFirmName,
    dynamic lawFirmImage,
    num? serviceId,
    String? serviceName,
    String? serviceImage,
    String? serviceStatusName,
    String? date,
    dynamic startedAt,
    dynamic endedAt,
    num? price,
    num? isPaid,
    dynamic question,
    dynamic attachmentUrl,
    num? serviceStatusCode,
    List<dynamic>? messages,
    List<dynamic>? reviews,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _customerId = customerId;
    _customerName = customerName;
    _customerImage = customerImage;
    _lawyerId = lawyerId;
    _lawyerName = lawyerName;
    _lawyerImage = lawyerImage;
    _lawFirmId = lawFirmId;
    _lawFirmName = lawFirmName;
    _lawFirmImage = lawFirmImage;
    _serviceId = serviceId;
    _serviceName = serviceName;
    _serviceImage = serviceImage;
    _serviceStatusName = serviceStatusName;
    _date = date;
    _startedAt = startedAt;
    _endedAt = endedAt;
    _price = price;
    _isPaid = isPaid;
    _question = question;
    _attachmentUrl = attachmentUrl;
    _serviceStatusCode = serviceStatusCode;
    _messages = messages;
    _reviews = reviews;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  LawyerBookedServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _customerName = json['customer_name'];
    _customerImage = json['customer_image'];
    _lawyerId = json['lawyer_id'];
    _lawyerName = json['lawyer_name'];
    _lawyerImage = json['lawyer_image'];
    _lawFirmId = json['law_firm_id'];
    _lawFirmName = json['law_firm_name'];
    _lawFirmImage = json['law_firm_image'];
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _serviceImage = json['service_image'];
    _serviceStatusName = json['service_status_name'];
    _date = json['date'];
    _startedAt = json['started_at'];
    _endedAt = json['ended_at'];
    _price = json['price'];
    _isPaid = json['is_paid'];
    _question = json['question'];
    _attachmentUrl = json['attachment_url'];
    _serviceStatusCode = json['service_status_code'];
    if (json['messages'] != null) {
      _messages = [];
      json['messages'].forEach((v) {
        // _messages?.add(Dynamic.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        // _reviews?.add(Dynamic.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _customerId;
  String? _customerName;
  String? _customerImage;
  num? _lawyerId;
  String? _lawyerName;
  String? _lawyerImage;
  dynamic _lawFirmId;
  dynamic _lawFirmName;
  dynamic _lawFirmImage;
  num? _serviceId;
  String? _serviceName;
  String? _serviceImage;
  String? _serviceStatusName;
  String? _date;
  dynamic _startedAt;
  dynamic _endedAt;
  num? _price;
  num? _isPaid;
  dynamic _question;
  dynamic _attachmentUrl;
  num? _serviceStatusCode;
  List<dynamic>? _messages;
  List<dynamic>? _reviews;
  String? _createdAt;
  String? _updatedAt;
  LawyerBookedServiceModel copyWith({
    num? id,
    num? customerId,
    String? customerName,
    String? customerImage,
    num? lawyerId,
    String? lawyerName,
    String? lawyerImage,
    dynamic lawFirmId,
    dynamic lawFirmName,
    dynamic lawFirmImage,
    num? serviceId,
    String? serviceName,
    String? serviceImage,
    String? serviceStatusName,
    String? date,
    dynamic startedAt,
    dynamic endedAt,
    num? price,
    num? isPaid,
    dynamic question,
    dynamic attachmentUrl,
    num? serviceStatusCode,
    List<dynamic>? messages,
    List<dynamic>? reviews,
    String? createdAt,
    String? updatedAt,
  }) =>
      LawyerBookedServiceModel(
        id: id ?? _id,
        customerId: customerId ?? _customerId,
        customerName: customerName ?? _customerName,
        customerImage: customerImage ?? _customerImage,
        lawyerId: lawyerId ?? _lawyerId,
        lawyerName: lawyerName ?? _lawyerName,
        lawyerImage: lawyerImage ?? _lawyerImage,
        lawFirmId: lawFirmId ?? _lawFirmId,
        lawFirmName: lawFirmName ?? _lawFirmName,
        lawFirmImage: lawFirmImage ?? _lawFirmImage,
        serviceId: serviceId ?? _serviceId,
        serviceName: serviceName ?? _serviceName,
        serviceImage: serviceImage ?? _serviceImage,
        serviceStatusName: serviceStatusName ?? _serviceStatusName,
        date: date ?? _date,
        startedAt: startedAt ?? _startedAt,
        endedAt: endedAt ?? _endedAt,
        price: price ?? _price,
        isPaid: isPaid ?? _isPaid,
        question: question ?? _question,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        serviceStatusCode: serviceStatusCode ?? _serviceStatusCode,
        messages: messages ?? _messages,
        reviews: reviews ?? _reviews,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get customerImage => _customerImage;
  num? get lawyerId => _lawyerId;
  String? get lawyerName => _lawyerName;
  String? get lawyerImage => _lawyerImage;
  dynamic get lawFirmId => _lawFirmId;
  dynamic get lawFirmName => _lawFirmName;
  dynamic get lawFirmImage => _lawFirmImage;
  num? get serviceId => _serviceId;
  String? get serviceName => _serviceName;
  String? get serviceImage => _serviceImage;
  String? get serviceStatusName => _serviceStatusName;
  String? get date => _date;
  dynamic get startedAt => _startedAt;
  dynamic get endedAt => _endedAt;
  num? get price => _price;
  num? get isPaid => _isPaid;
  dynamic get question => _question;
  dynamic get attachmentUrl => _attachmentUrl;
  num? get serviceStatusCode => _serviceStatusCode;
  List<dynamic>? get messages => _messages;
  List<dynamic>? get reviews => _reviews;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['customer_name'] = _customerName;
    map['customer_image'] = _customerImage;
    map['lawyer_id'] = _lawyerId;
    map['lawyer_name'] = _lawyerName;
    map['lawyer_image'] = _lawyerImage;
    map['law_firm_id'] = _lawFirmId;
    map['law_firm_name'] = _lawFirmName;
    map['law_firm_image'] = _lawFirmImage;
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['service_image'] = _serviceImage;
    map['service_status_name'] = _serviceStatusName;
    map['date'] = _date;
    map['started_at'] = _startedAt;
    map['ended_at'] = _endedAt;
    map['price'] = _price;
    map['is_paid'] = _isPaid;
    map['question'] = _question;
    map['attachment_url'] = _attachmentUrl;
    map['service_status_code'] = _serviceStatusCode;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
