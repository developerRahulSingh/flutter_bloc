import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/src/accountDetails.page.dart';
import 'package:fvbank/src/login.page.dart';
import 'package:fvbank/src/utils/security.storage.util.dart';
import 'package:fvbank/themes/common.theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MenuPage extends StatefulWidget {
  final String token;
  final dynamic accInfo;
  final dynamic userInfo;

  MenuPage({
    Key key,
    @required this.token,
    @required this.accInfo,
    @required this.userInfo,
  }) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPage> {
  String removePinText = 'Remove Login Pin';
  final PageRouteBuilder _loginRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return LoginPage();
    },
  );

//  final PageRouteBuilder _otpRoute = new PageRouteBuilder(
//    pageBuilder: (BuildContext context, _, __) {
//      return OTPComponent();
//    },
//  );

  @override
  void initState() {
    super.initState();
    _getPinSecurityText();
  }

  _getPinSecurityText() async {
    String text = "";
    var userSkippedPINSetup =
        await SecurityUtil.readValue('userSkippedPINSetup');
    print('userSkippedPINSetup:-$userSkippedPINSetup');
    var val = await SecurityUtil.isPINCodeSecurityEnabled();
    if (val == 'true') {
      text = 'Remove PIN';
    } else {
      if (userSkippedPINSetup == 'true') {
        text = 'Enable PIN';
      } else {
        text = 'Disable PIN';
      }
    }
    setState(() {
      removePinText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    _alertLogout() {
      Alert(
        context: context,
        title: 'Are you sure you want to logout?',
        buttons: [
          DialogButton(
            color: Color.fromRGBO(17, 17, 68, 1),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            //MODIFIED
            width: 120,
          ),
          DialogButton(
            color: Color.fromRGBO(17, 17, 68, 1),
            child: Text(
              'Sure',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              String val = await SecurityUtil.isPINCodeSecurityEnabled();
              Navigator.pushAndRemoveUntil(
                  context,
//                  val == 'true' ? _otpRoute : _loginRoute,
                  _loginRoute,
                  (Route<dynamic> r) => false);
            },
            width: 120,
          )
        ],
      ).show();
    }

    _alertRemovePin() {
      Alert(
        context: context,
        title: 'Please confirm',
        buttons: [
          DialogButton(
            color: Color.fromRGBO(17, 17, 68, 1),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            width: 120,
          ),
          DialogButton(
            color: Color.fromRGBO(17, 17, 68, 1),
            child: Text(
              'Okay',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await SecurityUtil.removePINCodeSecurity();
              Navigator.of(context, rootNavigator: true).pop();
            },
            width: 120,
          )
        ],
      ).show();
    }

    _onAlertOpen(alertText) {
      Alert(
        context: context,
//      type: AlertType.error,
        title: alertText,
        buttons: [
          DialogButton(
            color: Color.fromRGBO(17, 17, 68, 1),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            //MODIFIED
            width: 120,
          )
        ],
      ).show();
    }

    showSecurityMenu() async {
      String buttonName = "";
      var userSkippedPINSetup =
          await SecurityUtil.readValue('userSkippedPINSetup');
      print('userSkippedPINSetup:-$userSkippedPINSetup');
      var val = await SecurityUtil.isPINCodeSecurityEnabled();
      if (val == 'true') {
        buttonName = 'Remove PIN';
      } else {
        if (userSkippedPINSetup == 'true') {
          buttonName = 'Enable PIN';
        } else {
          buttonName = 'Disable PIN';
        }
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        if (buttonName == 'Remove PIN') {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _alertRemovePin();
                          });
                        } else if (buttonName == 'Enable PIN') {
//                          SecurityUtil.deleteValue(
//                              'userSkippedPINSetup');
                          SecurityUtil.writeValue(
                              'userSkippedPINSetup', 'false');
                          Navigator.of(context).pop();
                        } else if (buttonName == 'Disable PIN') {
                          SecurityUtil.writeValue(
                              'userSkippedPINSetup', 'true');
                          Navigator.of(context).pop();
                        } else {
                          _onAlertOpen('Remove Pin button Clicked');
                        }
                      },
                      child: new Text(
                        buttonName,
                        style: TextStyle(
                          color: CommonTheme.COLOR_DARK,
                          fontSize: CommonTheme.TEXT_SIZE_MEDIUM,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FlatButton(
                          color: Color.fromRGBO(17, 17, 68, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: CommonTheme.COLOR_PRIMARY,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: widget.userInfo != null
                        ? NetworkImage(widget.userInfo['image']['url'])
                        : AssetImage('images/user_fill.png'),
                  ),
                ),
              ),
              Text(
                widget.userInfo['display'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: CommonTheme.TEXT_SIZE_MEDIUM,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.userInfo['group']['name'] + ' Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: CommonTheme.TEXT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountDetailsPage(
                                        accInfo: widget.accInfo,
                                        userInfo: widget.userInfo != null
                                            ? widget.userInfo
                                            : null,
                                      )),
                            );
                          },
                          child: Text(
                            'Account Details',
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            _onAlertOpen(
                                'Please visit https://fvbank.us to contact support.');
                          },
                          child: Text(
                            'Help',
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            showSecurityMenu();
                          },
                          child: Text(
                            'Remove Login Pin',
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          onPressed: () {
                            _alertLogout();
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
