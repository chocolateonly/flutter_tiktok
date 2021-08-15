import 'package:image_picker/image_picker.dart';
import 'package:flutter_tiktok/views/Loading.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:flutter_tiktok/model/file.dart';
import 'package:flutter_tiktok/services/http_api.dart';

var baseUrl = 'https://taiwan.dev.hbbeisheng.com'; //Http.baseUrl

Future uploadVideo(context, max,folder_name) async {
  Loading.showLoading(context);
  var pcikeFile;
  String finalVideo='';
  final ImagePicker _picker = ImagePicker();
  try {
    pcikeFile = await _picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
  } on Exception catch (e) {
    print(e);
  }

  if (pcikeFile != null) {
    String path = pcikeFile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});

    var headPic = await HttpUtils.uploadFile(folder_name,formdata);
    print(headPic);

//    Dio dio = new Dio();
//    dio.options.contentType="application/x-www-form-urlencoded";
//    Response response = await dio.post<String>(baseUrl+"/*add_folder", data: formdata);
//    print(response);
//    if (response.statusCode == 200) {
//
////      var data=File.fromJson(response.data);
////      print(data);
////      print(data is Map);
////      var video_path=data.data.path;
//
//    }
    var video_path='upload/common/chat/video/20210801/20210801034341162780382148068.mp4';
    finalVideo=(baseUrl+'/' + video_path).toString();
  }
  Loading.hideLoading(context);
  return finalVideo;
}
Future<List> uploadImages(context, max,folder_name) async {
  Loading.showLoading(context);
  List<XFile>? resultList;
  final ImagePicker _picker = ImagePicker();
  try {
  resultList = await _picker.pickMultiImage(maxWidth: max);
  } on Exception catch (e) {
  print(e);
  }

  if (resultList == null) {
  return [];
  }

  List<String> finalImg = [];

  for (var i = 0; i < resultList.length; i++) {
  String path = resultList[i].path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formdata = FormData.fromMap(
  {"file": await MultipartFile.fromFile(path, filename: name)});
  var headPic = await HttpUtils.uploadFile(folder_name,formdata);
  print(headPic);

  /*Dio dio = new Dio();
  var respone = await dio.post<String>("/api/upload/image", data: formdata);
  if (respone.statusCode == 200) {
  print(respone);
  var headPic = '';
  finalImg.add((baseUrl + headPic).toString());
  }*/
  }
  Loading.hideLoading(context);
  return finalImg;
}
