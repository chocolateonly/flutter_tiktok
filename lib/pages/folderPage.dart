import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/model/add.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:flutter_tiktok/views/theme_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
import 'package:flutter_tiktok/config/router_manager.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';
class FolderPage extends StatefulWidget {
  var type='';
  FolderPage(this.type);
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  var _folderController = TextEditingController();
  var folderList=[];

  getFolderList()async{
    //获取文件夹列表
    var folders= await HttpUtils.getFolderList();
//    print(folders["folders"]);
//    print((folders["folders"]).keys.toList());
    setState(() {
      folderList=(folders["folders"]).keys.toList();
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
        title: Text('文件夹 '),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            ListView.builder(
              shrinkWrap: true, //解决无限高度问题
              physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
              itemCount: folderList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    //color: index==0?Colors.green:Colors.red,
                  ),
                  child: InkWell(
                    onTap: () {
                    if(widget.type=='')   Navigator.of(context).pushNamed(RouteName.file, arguments:[folderList[index]]);
                    else{
//                      选中
                      StorageManager.sharedPreferences.setString('indexFolder', folderList[index]);
                      Navigator.of(context).pushNamed(RouteName.home, arguments:[]);
                    }
                      },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xffeeeeee)))
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder,color: Colors.amber,),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(folderList[index],style: TextStyle(color: Colors.black),),
                          )),
                          Icon(Icons.menu,color: Colors.amber,),
                        ],
                      ),
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
                    child: Text('创建文件夹',style: TextStyle(fontSize: 15),),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          barrierDismissible: true, //点击遮罩是否关闭
                          builder: (context) {
                            return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        '创建文件夹',
                                        style: TextStyle(
                                            color: Colors.orange, fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FormItem(
                                        label: '文件夹名',
                                        controller: _folderController,
                                        inputType: TextInputType.text,
                                        labelWidth: 80.0,
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ThemeButton(
                                        title:'提交',
                                        onPressed: () async {
                                        if(_folderController.text=='')  showToast('请输入文件夹名称');
                                        var res =await HttpUtils.createFolder(
                                            _folderController.text);
                                        Add fold=Add.fromJson(res);
                                        print(fold.folder + '文件夹创建成功');
                                        showToast(fold.folder + '文件夹创建成功');
                                        Navigator.of(context).pop();
                                        getFolderList();
                                      },)
                                    ],
                                  ),
                                ));
                          });
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
