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
  Map userData;
  Map accountData;

  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  UserRepository userRepository;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    this.userRepository = new UserRepository();
    fetchUserData();
    fetchAccountDetail();
  }

  Future<dynamic> fetchUserData() async {
    await userRepository
        .getUserProfile(sessionToken: widget.token)
        .then((value) {
      setState(() {
        userData = value;
      });
    });
  }

  Future<dynamic> fetchAccountDetail() async {
    await userRepository
        .getAccounts(sessionToken: widget.token)
        .then((value) => {
              setState(() {
                accountData = value;
              }),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? DashboardPage(
              accInfo: accountData,
              userInfo: userData != null ? userData : null,
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
            inactiveColor: Colors.white,
            activeColor: CommonTheme.COLOR_PRIMARY,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text(''),
            inactiveColor: Colors.white,
            activeColor: CommonTheme.COLOR_PRIMARY,
          ),
        ],
      ),
    );
  }
}
