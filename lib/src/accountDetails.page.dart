import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/src/menu.page.dart';
import 'package:fvbank/themes/common.theme.dart';

class AccountDetailsPage extends StatefulWidget {
  final dynamic accInfo;
  final dynamic userInfo;

  AccountDetailsPage({
    Key key,
    @required this.accInfo,
    @required this.userInfo,
  }) : super(key: key);

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
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
    String nationality = '';
    String purposeOfAccount = '';
    String depositInstruction = '';
    String depositReferenceNumber = '';
    var array = widget.userInfo['customValues'];
    for (int i = 0; i < array.length; i++) {
      var singleData = array[i];
      var val = singleData['field']['internalName'];
      if (val == 'Individual_Nationality') {
        nationality = singleData['enumeratedValues'][0]['value'];
      }
      if (val == 'Purpose_Account') {
        purposeOfAccount = singleData['enumeratedValues'][0]['value'];
      }
      if (val == 'Metro_Details_Depsoit') {
        depositInstruction = singleData['stringValue'];
      }
      if (val == 'Metro_Account_USD') {
        depositReferenceNumber = singleData['stringValue'];
      }
    }
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
                rowItem(context, 'Group', widget.userInfo['group']['name']),
                rowItem(context, 'Full Name', widget.userInfo['display']),
                rowItem(context, 'Login Name', widget.userInfo['shortDisplay']),
                rowItem(context, 'Email', widget.userInfo['email']),
                rowItem(context, 'Mobile Phone',
                    widget.userInfo['phones'][0]['number']),
                rowItem(context, 'Nationality', nationality),
                rowItem(context, 'Purpose Of Account', purposeOfAccount),
                rowItem(context, 'Deposit instruction', depositInstruction),
                rowItem(context, 'Deposit Reference Number',
                    depositReferenceNumber),
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
                        widget.userInfo['addresses'][0]['street'] +
                            ', ' +
                            widget.userInfo['addresses'][0]['buildingNumber'],
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
                          widget.userInfo['addresses'][0]['zip']),
                      addressRowItem(context, 'City: ',
                          widget.userInfo['addresses'][0]['city']),
                      addressRowItem(context, 'Region / state: ',
                          widget.userInfo['addresses'][0]['region']),
                      addressRowItem(context, 'Country: ',
                          widget.userInfo['addresses'][0]['country']),
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

//
//class AccountDetailsPage extends StatelessWidget {
//
//  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
//    pageBuilder: (BuildContext context, _, __) {
//      return MenuPage();
//    },
//  );
//
//  dynamic rowItem(context, String label, String value) {
//    return Container(
//      padding: EdgeInsets.only(top: 4, right: 16, left: 16),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.only(top: 4),
//            width: MediaQuery.of(context).size.width * 0.4,
//            child: Text(
//              label,
//              style: TextStyle(
//                fontSize: CommonTheme.TEXT_SIZE_SMALL,
//                fontFamily: CommonTheme.FONT_LIGHT,
//                color: Colors.grey[600],
//              ),
//            ),
//          ),
//          Expanded(
//            child: Text(
//              value,
////              textAlign: TextAlign.right,
//              style: TextStyle(
//                fontSize: CommonTheme.TEXT_SIZE_SMALL,
//                fontFamily: CommonTheme.FONT_MEDIUM,
//                color: Colors.black,
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  dynamic addressRowItem(context, String label, String value) {
//    return Container(
//      padding: EdgeInsets.only(top: 4),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            child: Text(
//              label,
//              style: TextStyle(
//                fontSize: CommonTheme.TEXT_SIZE_SMALL,
//                fontFamily: CommonTheme.FONT_MEDIUM,
//                color: Colors.black,
//              ),
//            ),
//          ),
//          Expanded(
//            child: Text(
//              value,
//              style: TextStyle(
//                fontSize: CommonTheme.TEXT_SIZE_SMALL,
//                fontFamily: CommonTheme.FONT_LIGHT,
//                color: Colors.grey[600],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    double doubleTypeAmount = 0;
//    return MaterialApp(
//      home: Scaffold(
//        body: SafeArea(
//          child: Container(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Container(
//                  height: 44,
//                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                  child: Row(
//                    children: <Widget>[
//                      SizedBox(
//                        height: 32,
//                        width: 32,
//                        child: FlatButton(
////                              onPressed: () => Navigator.pop(context),
//                          onPressed: () => Navigator.pushAndRemoveUntil(
//                              context, _homeRoute, (Route<dynamic> r) => false),
//                          padding: EdgeInsets.all(0),
//                          child: Image.asset(
//                            'images/icon_nav_back_arrow_dark.png',
//                            width: 20,
//                            height: 20,
//                          ),
//                        ),
//                      ),
//                      Container(
//                        width: MediaQuery.of(context).size.width - 96,
//                        child: Text(
//                          'Account Details',
//                          textAlign: TextAlign.center,
//                          style: TextStyle(
//                            fontSize: CommonTheme.TEXT_SIZE_LARGE,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                Divider(
//                  height: 24,
//                  thickness: 1,
//                  color: Colors.grey,
//                ),
//                rowItem(context, 'Group', 'group'),
//                rowItem(context, 'Full Name', 'display'),
//                rowItem(context, 'Login Name', 'shortDisplay'),
//                rowItem(context, 'Email', 'email'),
//                rowItem(context, 'Mobile Phone', 'phones'),
//                rowItem(context, 'Nationality', 'nationality'),
//                rowItem(context, 'Purpose Of Account', 'purposeOfAccount'),
//                rowItem(context, 'Deposit instruction', 'depositInstruction'),
//                rowItem(context, 'Deposit Reference Number',
//                    'depositReferenceNumber'),
//                Divider(
//                  height: 24,
//                  thickness: 1,
//                  color: Colors.grey,
//                ),
//                Container(
//                  padding: EdgeInsets.symmetric(horizontal: 16),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text(
//                        'Address',
//                        textAlign: TextAlign.start,
//                        style: TextStyle(
//                          fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
//                          fontWeight: FontWeight.bold,
//                          color: CommonTheme.COLOR_PRIMARY,
//                        ),
//                      ),
//                      Text(
//                        'buildingNumber',
//                        style: TextStyle(
//                          fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
//                          color: Colors.grey[600],
//                        ),
//                      ),
//                      addressRowItem(context, 'Postal Code: ', 'addresses'),
//                      addressRowItem(context, 'City: ', 'addresses'),
//                      addressRowItem(context, 'Region / state: ', 'addresses'),
//                      addressRowItem(context, 'Country: ', 'addresses'),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
