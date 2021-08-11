import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/model/add.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/services/http_utils.dart';
class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {

  var _phoneController = TextEditingController();

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
        onPressed: ()async{
          showDialog(
              context:context,
              barrierDismissible:true,//点击遮罩是否关闭
              builder: (context) {
                return Dialog(
                    backgroundColor:Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child:Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '创建文件夹',
                            style: TextStyle(color: Colors.orange, fontSize:
                            16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormItem(label: '文件夹名',controller:_phoneController,
                              inputType: TextInputType.text,labelWidth:80.0,
                            textAlign: TextAlign.left,),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: ()async {
                              Add res=await HttpUtils.createFolder
                                (_phoneController.text);
                              print('创建文件夹成功');
                              print(res);
                              showToast(res.folder+'文件夹创建成功');
                              //获取文件夹列表
//                              var res1= await HttpUtils.getFolderList();

                            },
                            child: Text(
                              '提交',
                              style: TextStyle(color: Colors.orange,
                                  fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    )
                );
              }
          );
       },
        child: new Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
