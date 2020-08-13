import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fvbank/src/home.page.dart';
import 'package:fvbank/themes/common.theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:user_repository/user_repository.dart';

import 'bloc/authentationBloc/authenticationBloc.dart';
import 'loginBloc.dart';
import 'loginEvent.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _controllerUserName = TextEditingController();
  var _controllerPassword = TextEditingController();
  String username = '';
  String password = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final focus = FocusNode();
  final focusUsername = FocusNode();
  bool _signInStatus = false;

  void _singInStatusChange() {
    setState(() {
      _signInStatus = username != '' && username.length >= 6 && password != '';
    });
  }

  _alertLoginError() {
    Alert(
      context: context,
      title: 'Please enter proper credentials.',
      buttons: [
        DialogButton(
          color: Color.fromRGBO(17, 17, 68, 1),
          child: Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(focusUsername);
            _controllerUserName.clear();
            _controllerPassword.clear();
            Navigator.of(context, rootNavigator: true).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }

  handleAPIError(dynamic res) {
    setState(() {
      isLoading = false;
    });
    if (res['code'] == 'login') {
      _alertLoginError();
      return;
    } else if (res['code'] == 'loggedOut') {
      return;
    }
  }

  void _signInClicked() {
    print('Username And Password ==>> ');
    print(_controllerUserName.text);
    print(_controllerPassword.text);
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        username: _controllerUserName.text,
        password: _controllerPassword.text,
      ),
    );
    _nextScreen();
  }

  _nextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
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
            width: 120,
          )
        ],
      ).show();
    }

    return Stack(
      children: <Widget>[
        new SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Image.asset(
                  'images/Frame.png',
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: CommonTheme.TEXT_SIZE_LARGE,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  focusNode: focusUsername,
                  controller: _controllerUserName,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus);
                  },
                  onChanged: (text) {
                    username = text;
                    _singInStatusChange();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "USERNAME",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: TextField(
                  controller: _controllerPassword,
                  focusNode: focus,
                  onSubmitted: (v) {
                    if (username == '' || username.length <= 6) {
                      _onAlertOpen(
                        'Please enter valid user name.',
                      );
                    } else if (password == '') {
                      _onAlertOpen(
                        'Please enter valid password.',
                      );
                    } else {
                      if (_signInStatus == true) {
                        _signInClicked();
                      }
                    }
                  },
                  onChanged: (text) {
                    password = text;
                    _singInStatusChange();
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "PASSWORD",
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width * 0.35,
                child: FlatButton(
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  onPressed: _signInClicked,
//                  onPressed: _signInStatus
//                      ? () async {
//                          _signInClicked();
//                        }
//                      : null,
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: CommonTheme.TEXT_SIZE_SMALL,
                    ),
                  ),
                  color: Color.fromRGBO(17, 17, 68, 1),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: GestureDetector(
                  onTap: () => _onAlertOpen('Forgot Password'),
//                        onTap: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => OTPComponent()),
//                          );
//                        },
                  child: new Text(
                    "Forget Password",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: CommonTheme.COLOR_PRIMARY,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: InkWell(
                      onTap: () => _onAlertOpen('Need Help'),
                      child: new Text(
                        "Need Help?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: CommonTheme.COLOR_PRIMARY,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }
}
