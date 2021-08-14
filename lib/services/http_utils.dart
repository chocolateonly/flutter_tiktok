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

  static Future createFolder(folder_name) async {
    var response = await Http.post('/*add_folder', params: {'folder_name':folder_name});
    return response;
  }
  static Future getFolderList() async {
    var response = await Http.get('/*get_folders',params: {});
    return response;
  }
  static Future uploadFile(folder_name, file) async {
    var response = await Http.post('/*upload_file',params:{"folder_name":folder_name,"dir_name":file});
    return response;
  }
}
