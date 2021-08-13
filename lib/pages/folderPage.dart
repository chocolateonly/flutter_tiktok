import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/model/add.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:flutter_tiktok/views/theme_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/services/http_utils.dart';

class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  var _folderController = TextEditingController();
  var folderList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('文件 '),
      ),
      body: Container(
        color: Colors.white,
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
                                        //获取文件夹列表
                                      var folders= await HttpUtils.getFolderList();
                                        setState(() {
                                          folderList=folders;
                                        });
                                      },)
                                    ],
                                  ),
                                ));
                          });
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text('创建文件',style: TextStyle(fontSize: 15),),
                    onPressed: () => {},
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
