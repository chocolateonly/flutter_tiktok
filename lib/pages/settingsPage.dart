import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:flutter_tiktok/views/theme_button.dart';

import 'package:flutter_tiktok/config/router_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _ipController = TextEditingController();
  var _folderController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('baseurl foldername');
    if(StorageManager.sharedPreferences!=null) {
      var baseUrl = StorageManager.sharedPreferences.getString('baseUrl');
    var folderName=StorageManager.sharedPreferences.getString('indexFolder');

    print(baseUrl);
    print(folderName);
    if(baseUrl!=null){
    _ipController.text=baseUrl;
    }
    if(folderName!=null){
    _folderController.text=folderName;
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('设置'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            FormItem(
              label: 'ip设置',
              controller: _ipController,
              inputType: TextInputType.text,
              labelWidth: 80.0,
              textAlign: TextAlign.left,
            ),
            FormItem(
              label: '首页文件夹',
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
                if(_ipController.text=='') {
                  showToast('请输入ip地址');
                  return null;
                }
                if(_folderController.text=='') { showToast('请输入文件夹名称'); return null;}
                StorageManager.sharedPreferences.setString('baseUrl', _ipController.text);
                StorageManager.sharedPreferences.setString('indexFolder', _folderController.text);
                Navigator.of(context).pushNamed(RouteName.home, arguments:[]);

              },)
          ],
        ),
      ),
    );
  }
}
