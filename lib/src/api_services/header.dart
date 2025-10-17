import 'package:dio/dio.dart';

void setCustomHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

void setLanguageHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

void setAcceptHeader(Dio dio) {
  dio.options.headers['Accept'] = 'application/json';
}

void setContentHeader(Dio dio) {
  dio.options.headers['Content-Type'] = 'application/json';
}
