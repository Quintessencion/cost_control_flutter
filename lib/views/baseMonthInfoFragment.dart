import 'package:flutter/material.dart';

abstract class BaseMonthInfoFragment extends StatelessWidget {
  final double ITEM_HEIGHT = 50;

  Widget getDivider() {
    return Container(
      constraints: BoxConstraints.expand(height: 0.5),
      color: Color.fromRGBO(238, 238, 238, 1),
    );
  }

  Widget getContainerLine(String header, double value) {
    return Container(
      height: ITEM_HEIGHT,
      padding: EdgeInsets.only(top: 16, bottom: 12, left: 20, right: 12),
      child: Row(
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(101, 101, 101, 1),
            ),
          ),
          Expanded(child: Container()),
          Text(
            value.round().toString(),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(101, 101, 101, 1),
            ),
          ),
          Text(
            " ₽",
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(101, 101, 101, 1),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.arrow_forward_ios,
                size: 16, color: Color.fromRGBO(187, 187, 187, 1)),
          ),
        ],
      ),
    );
  }
}
