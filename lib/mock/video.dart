import 'dart:io';
import 'package:flutter_tiktok/config/storage_manager.dart';
import 'package:flutter_tiktok/services/GlobalConfig.dart';
import 'dart:convert';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tiktok/config/resouce_manager.dart';

Socket? socket;
var videoList = [
  'test-video-10.MP4',
  'test-video-6.mp4',
  'test-video-9.MP4',
  'test-video-8.MP4',
  'test-video-7.MP4',
  'test-video-1.mp4',
  'test-video-2.mp4',
  'test-video-3.mp4',
  'test-video-4.mp4',
];

class UserVideo {
   String url;
   String image;
   String? desc;

  UserVideo({
    required this.url,
    required this.image,
    this.desc,
  });

  static List<UserVideo> fetchVideo() {
    List<UserVideo> list = videoList
        .map((e) => UserVideo(image: '', url: 'https://static.ybhospital.net/$e', desc: 'test_video_desc'))
        .toList();
    return list;
  }

  static fetchVideo2(context) async {
    var folderName=getFolderName()!=''?getFolderName():'test';
    var  baseUrl = getIp()!=''?getIp() :'http://192.168.3.10:8080';
    //获取文件列表
    var folder= await HttpUtils.getFileList(folderName);
    print(folder["meta_hash"]);
    var meta_hash=folder["meta_hash"];
    var files=await HttpUtils.getMeta(folderName, meta_hash);
    print(jsonDecode(files));
    print((jsonDecode(files)["items"]).keys.toList());
    if((jsonDecode(files)["items"]).keys.toList().length==0) return [];
    List<UserVideo> list =[];
    (jsonDecode(files)["items"]).keys.toList()
        .forEach((e) async {
      if(e.contains('.mp4')||e.contains('.MP4')||e.contains('.mov')||e.contains('.m4a')){
        print('http://$baseUrl/$folderName/$e');
//        https://vd3.bdstatic.com/mda-mhjgcbhdu5p81hpi/sc/cae_h264_clips/1629518456765967943/mda-mhjgcbhdu5p81hpi.mp4?auth_key=1629544319-0-0-4596aed3e981c64982a55d8bdb014ac5&bcevod_channel=searchbox_feed&pd=1&pt=3&abtest=
        list.add(UserVideo(image: '', url: baseUrl+'/'+folderName+'/$e', desc: 'test_vi'
            'deo'
            '_desc'));
      }else if(e.contains('.jpg')||e.contains('.jpeg')||e.contains('.png')||e.contains('.gif')||e.contains('.webp')||e.contains('.bmp')){
        list.add(UserVideo(image:  baseUrl+'/'+folderName+'/$e', url: '', desc: 'test_video_desc'));
      }
    });
    print(list);
    print('获取本地数据：');
//    StorageManager.sharedPreferences.remove('localFiles');
    var exist_files=await getLocalFiles(context);
    print(exist_files);
//    判断有无  无下载 有换本地地址
    list.forEach((item){
      var downloadUrl=item.url==''?item.image:item.url;
      var name=downloadUrl.substring(downloadUrl.lastIndexOf("/") + 1, downloadUrl.length);
      print(name+':11');
      print(exist_files[name]);
      if( exist_files.containsKey(name)){
//      换地址
        if(item.url!='') item.url=exist_files[name];
        else item.image=exist_files[name];
      }else{
//        下载
        if(item.url!='') downloadFile(context,item.url);
        else if(item.image!='') downloadFile(context,item.image);
      }


    });
    print('地址更新');
    print(list);
    return list;
  }


  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}
