import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/src/menu.page.dart';
import 'package:fvbank/themes/common.theme.dart';

class AccountDetailsPage extends StatelessWidget {
  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return MenuPage();
    },
  );

  dynamic rowItem(context, String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4, right: 16, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 4),
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_LIGHT,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
//              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_MEDIUM,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic addressRowItem(context, String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              label,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_MEDIUM,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                fontFamily: CommonTheme.FONT_LIGHT,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double doubleTypeAmount = 0;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: FlatButton(
//                              onPressed: () => Navigator.pop(context),
                          onPressed: () => Navigator.pushAndRemoveUntil(
                              context, _homeRoute, (Route<dynamic> r) => false),
                          padding: EdgeInsets.all(0),
                          child: Image.asset(
                            'images/icon_nav_back_arrow_dark.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 96,
                        child: Text(
                          'Account Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: CommonTheme.TEXT_SIZE_LARGE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24,
                  thickness: 1,
                  color: Colors.grey,
                ),
                rowItem(context, 'Group','group'),
                rowItem(
                    context, 'Full Name', 'display'),
                rowItem(context, 'Login Name','shortDisplay'),
                rowItem(context, 'Email','email'),
                rowItem(context, 'Mobile Phone','phones'),
                rowItem(context, 'Nationality', 'nationality'),
                rowItem(context, 'Purpose Of Account', 'purposeOfAccount'),
                rowItem(context, 'Deposit instruction', 'depositInstruction'),
                rowItem(context, 'Deposit Reference Number',
                    'depositReferenceNumber'),
                Divider(
                  height: 24,
                  thickness: 1,
                  color: Colors.grey,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Address',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                          fontWeight: FontWeight.bold,
                          color: CommonTheme.COLOR_PRIMARY,
                        ),
                      ),
                      Text(
                        'buildingNumber',
                        style: TextStyle(
                          fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                          color: Colors.grey[600],
                        ),
                      ),
                      addressRowItem(context, 'Postal Code: ',
                          'addresses'),
                      addressRowItem(context, 'City: ','addresses'),
                      addressRowItem(context, 'Region / state: ','addresses'),
                      addressRowItem(context, 'Country: ','addresses'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
