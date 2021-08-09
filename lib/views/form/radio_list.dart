import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
两行：
* h：180  crossAxisCount: 3, childAspectRatio: 2.1
*
* */
class RadioList extends StatefulWidget {
  List? options = [];

  var selected;

  var isRow;

  var onChange;

  var childAspectRatio;

  var crossAxisCount;

  dynamic? height = 180;

  RadioList({this.options, this.selected, this.isRow: false, this.onChange, this.crossAxisCount: 3, this.childAspectRatio: 2.1, this.height});

  @override
  _RadioListState createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  List getRadioList() {
    var list = [];

    for (var i = 0; i < widget.options!.length; i++) {
      list.add(Item(i));
    }

    return list;
  }

  Widget Item(i) {
    return Container(
      child: InkWell(
        onTap: () {
          widget.onChange(i);
        },
        child: Row(
          children: <Widget>[
           Radio(
             value: 'I',
             groupValue: widget.selected,
             onChanged:(index) {
               setState(() {
                 widget.onChange(index);
               });
             },
           ),

            Text(
              widget.options![i],
              style: TextStyle(fontSize: 26),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isRow
        ? Row(
      children: <Widget>[...getRadioList()],
    )
        : Column(
            children: <Widget>[...getRadioList()],
          );
  }
}
