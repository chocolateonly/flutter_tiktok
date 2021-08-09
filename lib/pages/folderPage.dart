import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';

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

          var res=await HttpUtils.createFolder('test');
          print('创建文件');
          print(res);
             return null;

          showDialog(
              context:context,
              barrierDismissible:true,//点击遮罩是否关闭
              builder: (context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child:Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '创建文件夹',
                            style: TextStyle(color: Theme.of(context).accentColor, fontSize: 36),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormItem(label: '文件名', controller: _phoneController, readOnly: true, inputType: TextInputType.text),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: ()async {
                              var res=await HttpUtils.createFolder(_phoneController.text);
                              print('创建文件');
                              print(res);
                            },
                            child: Text(
                              '提交',
                              style: TextStyle(color: Colors.orange, fontSize: 26),
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
