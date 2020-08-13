import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvbank/themes/common.theme.dart';

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;

  final OutlineInputBorder outlineInputBorder;

  PINNumber({this.textEditingController, this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      alignment: Alignment.center,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(right: -3, bottom: 75),
            border: outlineInputBorder,
            filled: false,
            fillColor: CommonTheme.COLOR_DEFAULT),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          color: CommonTheme.COLOR_DEFAULT,
        ),
      ),
    );
  }
}
