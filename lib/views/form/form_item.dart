import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class FormItem extends StatefulWidget {
  String? inputDefaultValue = ''; //默认值
  String label; //标题
  String? type = 'input'; //表单项
  TextInputType? inputType = TextInputType.text; //textFiled 键盘类型
  TextAlign textAlign = TextAlign.right; //textFiled 文字方向
  TextEditingController? controller = TextEditingController();
  bool isRequired;
  bool readOnly;
  final maxLines;
  String hintText = "";
  var hasBottomBorder = true;
  var textColor;

  var labelWidth;

  FormItem(
      {this.inputDefaultValue,
      this.label = 'title',
      this.type,
      this.inputType,
      this.textAlign: TextAlign.right,
      this.controller,
      this.isRequired: false,
      this.readOnly: false,
      this.maxLines: 1,
      this.hintText: "",
      this.hasBottomBorder: true,
      this.textColor: 0xff666666,
      this.labelWidth: 150.0});

  @override
  _FormItemState createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  Widget ItemWidget() {
    print(widget.labelWidth);
    switch (widget.type) {
      default:
        return Container(
            decoration: BoxDecoration(
                border: Border(bottom: widget.hasBottomBorder ? BorderSide(color: Color(0xffeeeeee)) : BorderSide(color: Colors.transparent))),
            child: Row(
              children: <Widget>[
                Container(
                  width: widget.labelWidth,
                  child: Row(
                    children: <Widget>[
                      widget.isRequired
                          ? Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(''),
                      Text(
                        widget.label,
                        style: TextStyle(color: Color(widget.textColor)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: widget.controller,
                      readOnly: widget.readOnly,
                      style: TextStyle(color: Color(0xff666666)),
                      textAlign: widget.textAlign,
                      maxLines: widget.maxLines,
                      keyboardType: widget.inputType,
                      decoration: InputDecoration(hintText: widget.hintText, hintStyle: TextStyle(color: Colors.grey,fontSize: 14), border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ItemWidget();
  }
}
