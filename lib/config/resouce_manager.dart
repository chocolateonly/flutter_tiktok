import 'package:image_picker/image_picker.dart';
import 'package:flutter_tiktok/views/Loading.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:flutter_tiktok/model/file.dart';
import 'package:flutter_tiktok/services/http_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
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
  print('aaaaaaaaaaaaaaaa');
  print(path);
  var file_root_path=await getExternalStorageDirectory();
  print(file_root_path);
  var headPic = await HttpUtils.uploadFile(folder_name,path);
  print(headPic);
  }
  Loading.hideLoading(context);
  return finalImg;
}
Future<List> uploadFile (context, max,folder_name) async {
  Loading.showLoading(context);
  List<XFile>? resultList;
  List<String> finalImg = [];
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  print('ssssssssssssssssss');
  print(result!.files.single.path);

  if(result!=null){
  var path=result.files.single.path;
  var name = path!.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formdata = FormData.fromMap(
  {"file": await MultipartFile.fromFile(path, filename: name)});
  var headPic = await HttpUtils.uploadFile(folder_name, formdata);
  print(headPic);
  }
  Loading.hideLoading(context);
  return finalImg;
}