 import 'package:dio/dio.dart';
import 'package:flutter_tiktok/services/http_api.dart';
int pageSize = 20;

class HttpUtils {
  static Future uploadImg(FormData file) async {
    var response = await Http.post('/api/upload/image', params: file);
    return response.data!["path"];
  }

  static Future uploadVideo(file) async {
    var response = await Http.post('/api/upload/video', params: file);
    return response.data!["path"];
  }
}
