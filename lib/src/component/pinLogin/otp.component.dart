import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvbank/src/component/pinLogin/keyboard.component.dart';
import 'package:fvbank/src/component/pinLogin/pinNumber.component.dart';
import 'package:fvbank/src/home.page.dart';
import 'package:fvbank/src/interfaces/api_interfaces.dart';
import 'package:fvbank/src/login.page.dart';
import 'package:fvbank/src/utils/security.storage.util.dart';
import 'package:fvbank/themes/common.theme.dart';

List<String> currentPin = ['', '', '', '', '', ''];

TextEditingController pinOneController = TextEditingController();
TextEditingController pinTwoController = TextEditingController();
TextEditingController pinThreeController = TextEditingController();
TextEditingController pinFourController = TextEditingController();
TextEditingController pinFiveController = TextEditingController();
TextEditingController pinSixController = TextEditingController();

final outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: BorderSide(color: Colors.red),
);

int pinIndex = 0;

class OTPComponent extends StatefulWidget {
  @override
  _OTPComponentState createState() => _OTPComponentState();
}

class _OTPComponentState extends State<OTPComponent> {
  bool isLoading = false;

  handleAPIError(dynamic res) {
    setState(() {
      isLoading = false;
    });
    if (res['code'] == 'loggedOut') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }
  }

  void _signIn(context, String username, String password) async {
    setState(() {
      isLoading = true;
    });
    var res = await APIInterfaces.loginUser(username, password);
    print('RES:-$res');
//    if (res.containsKey('code')) {
//      handleAPIError(res);
//    } else {
    if (!res.containsKey('sessionToken')) {
      setState(() {
        isLoading = false;
      });
    }

    var sessionToken = res['sessionToken'];
    print('ST:-$sessionToken');
//      Store SessionToken

    var resUserProfile = await APIInterfaces.getUserProfile(sessionToken);
    print('RES USER:-$resUserProfile');

    if (resUserProfile.containsKey('code')) {
      handleAPIError(resUserProfile);
    } else {
      if (!resUserProfile.containsKey('display')) {
        setState(() {
          isLoading = false;
        });
      }
//        Store User data
      var resGetAccounts = await APIInterfaces.getAccounts(sessionToken);
//        if (resGetAccounts.containsKey('code')) {
//          handleAPIError(resGetAccounts);
//        } else {
      var accountData = resGetAccounts[0];
      var accountType = resGetAccounts[0]['type']['internalName'];
      print('AccountType ==>> $accountType');
      print('RES GET ACCOUNTS:-$accountData');
      if (!accountData.containsKey('number')) {
        setState(() {
          isLoading = false;
        });
      }
//Store Account data
      var resGetAccountsHistory =
          await APIInterfaces.getAccountsHistory(sessionToken, accountType);
//          if (resGetAccountsHistory.containsKey('code')) {
//            handleAPIError(resGetAccountsHistory);
//          } else {
      print('RES GET ACCOUNTS HISTORY==>> $resGetAccountsHistory');
//         Store Account history
      clearAllPin();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
//          }
//        }
    }
//    }
  }

  pinIndexSetUp(context, String enteredPin) async {
    if (pinIndex < 6) {
      if (pinIndex == 0)
        pinIndex = 1;
      else if (pinIndex < 6) pinIndex++;
      setPin(pinIndex, enteredPin);
      currentPin[pinIndex - 1] = enteredPin;
      String strPin = '';
      currentPin.forEach((e) {
        strPin += e;
      });
      if (pinIndex == 6) {
        print('PIN Index ==>> $strPin');
        String pinData = await SecurityUtil.getPINCodeSecurity();
        print('pinData:-$pinData');
        if (strPin == pinData) {
          String username = await SecurityUtil.getUserName();
          String password = await SecurityUtil.getUserPassword();
          print('userName:-$username');
          print('password:-$password');
          if (username != '' && password != '') {
            clearAllPin();
            _signIn(context, username, password);
          } else {
            await SecurityUtil.removePINCodeSecurity();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        }
      }
    }
  }

  buildNumberPad(context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: <Widget>[
          KeyboardNumber(
            n: 1,
            onPressed: () {
              pinIndexSetUp(context, '1');
            },
          ),
          KeyboardNumber(
            n: 2,
            onPressed: () {
              pinIndexSetUp(context, '2');
            },
          ),
          KeyboardNumber(
            n: 3,
            onPressed: () {
              pinIndexSetUp(context, '3');
            },
          ),
          KeyboardNumber(
            n: 4,
            onPressed: () {
              pinIndexSetUp(context, '4');
            },
          ),
          KeyboardNumber(
            n: 5,
            onPressed: () {
              pinIndexSetUp(context, '5');
            },
          ),
          KeyboardNumber(
            n: 6,
            onPressed: () {
              pinIndexSetUp(context, '6');
            },
          ),
          KeyboardNumber(
            n: 7,
            onPressed: () {
              pinIndexSetUp(context, '7');
            },
          ),
          KeyboardNumber(
            n: 8,
            onPressed: () {
              pinIndexSetUp(context, '8');
            },
          ),
          KeyboardNumber(
            n: 9,
            onPressed: () {
              pinIndexSetUp(context, '9');
            },
          ),
          Container(
            width: 64.0,
            height: 40.0,
            child: MaterialButton(
              onPressed: null,
              child: SizedBox(),
            ),
          ),
          KeyboardNumber(
            n: 0,
            onPressed: () {
              pinIndexSetUp(context, '0');
            },
          ),
          Container(
            width: 64.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              color: CommonTheme.COLOR_PIN_NUMBER_BG,
            ),
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: () {
                clearPin();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: 90.0,
              child: Image.asset(
                'images/icon_backspace_black.png',
                color: CommonTheme.COLOR_DARK,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
            color: Colors.black.withOpacity(0.3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              color: CommonTheme.COLOR_BRIGHT,
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Login PIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    'images/Frame.png',
                    color: CommonTheme.COLOR_DARK,
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    alignment: Alignment(0, 0.5),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        buildSecurityText(),
                        buildPinRow(),
                      ],
                    ),
                  ),
                  buildNumberPad(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: new Text(
                        "Login Again",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: CommonTheme.COLOR_PRIMARY,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Align(
            child: loadingIndicator,
            alignment: FractionalOffset.center,
          ),
        ],
      ),
    );
  }
}

clearPin() {
  if (pinIndex == 0) {
    pinIndex = 0;
  } else if (pinIndex == 6) {
    setPin(pinIndex, '');
    currentPin[pinIndex - 1] = '';
    pinIndex--;
  } else {
    setPin(pinIndex, '');
    currentPin[pinIndex - 1] = '';
    pinIndex--;
  }
}

clearAllPin() {
  pinIndex = 0;
  setPin(1, '');
  setPin(2, '');
  setPin(3, '');
  setPin(4, '');
  setPin(5, '');
  setPin(6, '');
}

setPin(int n, String enteredPin) {
  switch (n) {
    case 1:
      pinOneController.text = enteredPin;
      break;
    case 2:
      pinTwoController.text = enteredPin;
      break;
    case 3:
      pinThreeController.text = enteredPin;
      break;
    case 4:
      pinFourController.text = enteredPin;
      break;
    case 5:
      pinFiveController.text = enteredPin;
      break;
    case 6:
      pinSixController.text = enteredPin;
      break;
  }
}

buildPinRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinOneController,
      ),
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinTwoController,
      ),
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinThreeController,
      ),
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinFourController,
      ),
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinFiveController,
      ),
      PINNumber(
        outlineInputBorder: outlineInputBorder,
        textEditingController: pinSixController,
      ),
    ],
  );
}

buildSecurityText() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      'Enter PIN',
      style: TextStyle(fontSize: CommonTheme.TEXT_SIZE_MEDIUM),
    ),
  );
}
