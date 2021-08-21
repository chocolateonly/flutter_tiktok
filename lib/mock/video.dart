import 'dart:io';

import 'dart:convert';
import 'package:flutter_tiktok/services/http_utils.dart';
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
  final String url;
  final String image;
  final String? desc;

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

  static fetchVideo2() async {
    //获取文件列表
    var folder= await HttpUtils.getFileList('test');
    print(folder["meta_hash"]);
    var meta_hash=folder["meta_hash"];
    var files=await HttpUtils.getMeta('test', meta_hash);
    print(jsonDecode(files));
    print((jsonDecode(files)["items"]).keys.toList());
    List<UserVideo> list =[];
    (jsonDecode(files)["items"]).keys.toList()
        .forEach((e){
      if(e.contains('.mp4')){
        print('http://192.168.3.10:8080/test/$e');
//        https://vd3.bdstatic.com/mda-mhjgcbhdu5p81hpi/sc/cae_h264_clips/1629518456765967943/mda-mhjgcbhdu5p81hpi.mp4?auth_key=1629544319-0-0-4596aed3e981c64982a55d8bdb014ac5&bcevod_channel=searchbox_feed&pd=1&pt=3&abtest=
        list.add(UserVideo(image: '', url: 'http://192.168.3.10:8080/test/$e', desc: 'test_video_desc'));
      }
    });
    print('aaa');
    print(list);
    return list;
  }


  @override
  String toString() {
    return 'image:$image' '\nvideo:$url';
  }
}
