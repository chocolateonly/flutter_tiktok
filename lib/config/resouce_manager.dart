import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tiktok/views/Loading.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:flutter_tiktok/model/file.dart';
import 'package:flutter_tiktok/services/http_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';
Future<List> uploadFile (context, max,folder_name) async {
  Loading.showLoading(context);
  List<XFile>? resultList;
  List<String> finalImg = [];
  FilePickerResult? result = await FilePicker.platform.pickFiles();

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
// 申请权限
Future<bool> _checkPermission() async {
  // 先对所在平台进行判断
  bool status = await Permission.storage.isGranted;
  //判断如果还没拥有读写权限就申请获取权限
  if (!status) {
     await Permission.storage.request().isGranted;
     return false;
  }
  return true;
}
var local_files={};
// 获取存储路径
Future<String> _findLocalPath(context) async {
  // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
  // 如果是android，使用getExternalStorageDirectory
  // 如果是iOS，使用getApplicationSupportDirectory
  final directory = Theme.of(context).platform == TargetPlatform.android
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  return directory!.path;
}
// 根据 downloadUrl 和 savePath 下载文件
downloadFile(context,downloadUrl ) async {
  var status=await _checkPermission();
  print('下载文件${status}');

  if(status==true){
    // 获取存储路径
    var savePath=await _findLocalPath(context);
    var _localPath = savePath + '/Download';
    print('即将下载，获取存储路径');
    print(_localPath);
    final savedDir = Directory(_localPath);
    // 判断下载路径是否存在
    bool hasExisted = await savedDir.exists();
    // 不存在就新建路径
    if (!hasExisted) {
      savedDir.create();
    }
     print(hasExisted);
     var name = downloadUrl.substring(downloadUrl.lastIndexOf("/") + 1, downloadUrl.length);
        //   文件是否存在
        var files=await getLocalFiles(context);
        if(files.containsKey(name)){
          //fixme:删除文件
          files.remove(name);
          return;
        }
        await FlutterDownloader.enqueue(
          url: downloadUrl,
          savedDir: _localPath,
          showNotification: false,
          // show download progress in status bar (for Android)
          openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
        );
    local_files[name]=_localPath+'/'+name;
    StorageManager.sharedPreferences.setString('localFiles',jsonEncode(local_files));
  }
}
Future getLocalFiles(context)async {
  var files=StorageManager.sharedPreferences.getString('localFiles');
 if(files!=null)  files=jsonDecode(files);

  return  files??{};

}