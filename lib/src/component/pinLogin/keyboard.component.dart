import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvbank/themes/common.theme.dart';

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;

  KeyboardNumber({this.n, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        color: CommonTheme.COLOR_PIN_NUMBER_BG,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 90.0,
        child: Text(
          '$n',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: CommonTheme.TEXT_SIZE_DEFAULT *
                MediaQuery.of(context).textScaleFactor,
            color: CommonTheme.COLOR_DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
