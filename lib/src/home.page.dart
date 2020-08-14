import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:fvbank/src/dashboard.page.dart';
import 'package:fvbank/src/menu.page.dart';
import 'package:fvbank/themes/common.theme.dart';
import 'package:user_repository/user_repository.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({Key key, @required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  List<dynamic> userData;

  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
//    UserRepository()
//        .getUserProfile(sessionToken: widget.token)
//        .then((value) => {
//      print("dashboard 1234 ==>> $value"),
//      setState(() {
//        userData = value;
//      }),
//      print("dashboard 1234 ==>> $userData")
//    });
//    print("dashboard ==>> $userData");
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? DashboardPage(
              token: widget.token,
            )
          : MenuPage(),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: CommonTheme.COLOR_DARK,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,

        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.timeline),
            title: Text(''),
            activeColor: CommonTheme.COLOR_PRIMARY,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text(''),
            activeColor: CommonTheme.COLOR_PRIMARY,
          ),
        ],
      ),
    );
  }
}
