import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/model/add.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:flutter_tiktok/views/theme_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:flutter_tiktok/config/resouce_manager.dart';
var baseUrl1= 'http://192.168.3.10:8080';
class FilePage extends StatefulWidget {
  var title;
  FilePage(this.title);

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  var fileList=[];

  getFolderList()async{
    //获取文件列表
    var folder= await HttpUtils.getFileList(widget.title);
    print(folder["meta_hash"]);
    var meta_hash=folder["meta_hash"];
    var files=await HttpUtils.getMeta(widget.title, meta_hash);
    print(jsonDecode(files));
    print((jsonDecode(files)["items"]).keys.toList());
    setState(() {
      var list =(jsonDecode(files)["items"]).keys.toList();
      fileList=list;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFolderList();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true, //解决无限高度问题
              physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    //color: index==0?Colors.green:Colors.red,
                  ),
                  child: InkWell(
                    onTap: () {

                      },
                    child: Row(
                      children: [
                        Icon(Icons.assignment,color: Colors.amber,),
                        Expanded(child: Text(fileList[index],style: TextStyle(color: Colors.black),)),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: ColorPlate.orange,
        onPressed: () async {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return CupertinoActionSheet(
                title: Text('操作'),
                actions: [
                  CupertinoActionSheetAction(
                    child: Text('上传文件',style: TextStyle(fontSize: 15),),
                    onPressed: () async {
                         var file=await uploadFile(context,1.0,widget.title);
                         showToast('文件上传成功');
                         Navigator.of(context).pop();
                         getFolderList();
                    },
                  ),
                ],
                cancelButton: CupertinoButton(
                  child: Text('取消',style: TextStyle(fontSize: 15),),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              );
            },
          );
        },
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
