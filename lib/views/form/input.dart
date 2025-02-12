import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormItem extends StatefulWidget {
  String? inputDefaultValue='';//默认值
  String label;//标题
  String? type='input';//表单项
  TextInputType? inputType=TextInputType.text;//textFiled 键盘类型
  TextAlign textAlign=TextAlign.right;//textFiled 文字方向
  TextEditingController? controller=TextEditingController();
  bool isRequired;
  bool readOnly;
  final maxLines;

  FormItem({
    this.inputDefaultValue,
    this.label='title',
    this.type,
    this.inputType,
    this.textAlign:TextAlign.right,
    this.controller,
    this.isRequired:false,
    this.readOnly:false,
    this.maxLines:1
  });

  @override
  _FormItemState createState() => _FormItemState();

}

class _FormItemState extends State<FormItem> {


  Widget ItemWidget(){
    switch(widget.type){
      default:return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xffeeeeee))
              )
          ),
          child: Row(
            children: <Widget>[
              Container(
                width:100,
                child: Row(
                    children: <Widget>[
                      widget.isRequired?Text("*",style: TextStyle(color: Colors.red),):Text(''),
                      Text(widget.label,style: TextStyle(color: Color(0xff666666)),)
                    ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  style: TextStyle(color:Color(0xff999999) ),
                  textAlign: widget.textAlign,
                  maxLines:widget.maxLines,
                  keyboardType:widget.inputType,
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                ),
              ),
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget();
  }
}
