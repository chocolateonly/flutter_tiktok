import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/views/form/form_item.dart';
import 'package:flutter_tiktok/views/theme_button.dart';

import 'package:flutter_tiktok/config/router_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';
import 'package:flutter_tiktok/views/form/radio_list.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
const defaultPort='80';
class _SettingsPageState extends State<SettingsPage> {
  var _ipController = TextEditingController();
  var _portController = TextEditingController();
  var httpIndex=0;
  var httpList=['http','https'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('baseurl foldername');
    if(StorageManager.sharedPreferences!=null) {
      var baseHttp= StorageManager.sharedPreferences.getInt('baseHttp');
      var baseIP = StorageManager.sharedPreferences.getString('baseIP');
      var basePort=StorageManager.sharedPreferences.getString('basePort');
      _ipController.text=baseIP??'';
      _portController.text=basePort??defaultPort;
      if(baseHttp!=null) httpIndex=baseHttp;
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
            RadioList(
            options: httpList,
            selected: httpIndex,
            isRow: true,
            height: 50,
            crossAxisCount: 2,
            childAspectRatio: 1.7,
            onChange: (i) {
              print(i);
              setState(() {
                httpIndex = i;
              });
            }),
            FormItem(
              label: 'IP地址',
              controller: _ipController,
              inputType: TextInputType.text,
              labelWidth: 80.0,
              textAlign: TextAlign.left,
            ),
            Row(
              children: [
                Expanded(
                  child: FormItem(
                    label: '端口号',
                    controller: _portController,
                    inputType: TextInputType.text,
                    labelWidth: 80.0,
                    textAlign: TextAlign.left,
                  ),
                ),
                InkWell(
                  child: Text('设置默认',style: TextStyle(color: Colors.orange),),
                  onTap: (){
                    _portController.text=defaultPort;
                  },
                )
              ],
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
                if(_portController.text=='') { showToast('请输入端口号'); return null;}
                var baseUrl=httpList[httpIndex]+'://'+ _ipController.text+':'+_portController.text;
                StorageManager.sharedPreferences.setString('baseUrl', baseUrl);
                StorageManager.sharedPreferences.setString('baseIP', _ipController.text);
                StorageManager.sharedPreferences.setString('basePort', _portController.text);
                StorageManager.sharedPreferences.setInt('baseHttp', httpIndex);
                Navigator.of(context).pushNamed(RouteName.folder, arguments:['select']);

              },)
          ],
        ),
      ),
    );
  }
}
