import 'package:flutter/material.dart';
import 'package:cost_control/entities/calcItem.dart';

class CalcItemView extends StatefulWidget {
  final CalcItem item;
  final Function(String) onChangeDescription;

  CalcItemView({this.item, this.onChangeDescription});

  @override
  State<StatefulWidget> createState() => _CalcItemViewState();
}

class _CalcItemViewState extends State<CalcItemView> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.item.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, left: 20, right: 20),
          child: TextField(
            controller: _controller,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Добавить описание",
              hintStyle: TextStyle(color: Color.fromRGBO(122, 149, 242, 1)),
              enabledBorder: new UnderlineInputBorder(
                  borderSide:
                      new BorderSide(color: Color.fromRGBO(122, 149, 242, 1))),
            ),
            onChanged: widget.onChangeDescription,
          ),
        ),
        Expanded(child: Container()),
        Text(
          widget.item.value,
          style: TextStyle(
            fontFamily: "SFPro",
            fontSize: 78,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        Text(
          widget.item.expression,
          style: TextStyle(
            fontFamily: "SFPro",
            fontSize: 28,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
