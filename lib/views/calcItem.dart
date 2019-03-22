import 'package:flutter/material.dart';
import 'package:cost_control/entities/calcItem.dart';
import 'package:cost_control/utils/moneyUtils.dart';

class CalcItemView extends StatefulWidget {
  final CalcItem item;
  final Function(String) onChangeDescription;

  CalcItemView({this.item, this.onChangeDescription});

  @override
  State<StatefulWidget> createState() => _CalcItemViewState();
}

class _CalcItemViewState extends State<CalcItemView> {
  TextEditingController _controller;
  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    _controller = new TextEditingController(text: widget.item.description);
    _focusNode.addListener(() {
      widget.item.hashFocus = _focusNode.hasFocus;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.hashFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    TextSelection lastSelection = _controller.selection.copyWith();
    _controller.text = widget.item.description;
    _controller.selection = lastSelection;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, left: 20, right: 20),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
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
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(
            MoneyUtils.calc(widget.item.value),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 78,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(
            widget.item.expression,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 28,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
