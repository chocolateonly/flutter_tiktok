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
  {"file": await MultipartFile.fromFile(path, filename: name),'folder_name':folder_name,"dir_name":"/"});
  var headPic = await HttpUtils.uploadFile(formdata);
  }
  Loading.hideLoading(context);
  return finalImg;
}
Future uploadVideo(context, max,folder_name) async {
  Loading.showLoading(context);
  var pcikeFile;
  String finalVideo='';
  final ImagePicker _picker = ImagePicker();
  try {
    pcikeFile = await _picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
  } on Exception catch (e) {
    print(e);
  }

  if (pcikeFile != null) {
    String path = pcikeFile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name),'folder_name':folder_name,"dir_name":"/"});
    var headPic = await HttpUtils.uploadFile(formdata);
    print(headPic);
  }
  Loading.hideLoading(context);
  return finalVideo;
}
Future<List> uploadImages(context, max,folder_name) async {
  Loading.showLoading(context);
  XFile? result;
  final ImagePicker _picker = ImagePicker();
  try {
  result = await _picker.pickImage(source: ImageSource.camera);
  } on Exception catch (e) {
  print(e);
  }

  if (result == null) {
  return [];
  }

  List<String> finalImg = [];

  String path = result.path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formdata = FormData.fromMap(
  {"file": await MultipartFile.fromFile(path, filename: name),'folder_name':folder_name,"dir_name":"/"});
  var headPic = await HttpUtils.uploadFile(formdata);

  Loading.hideLoading(context);
  return finalImg;
}
