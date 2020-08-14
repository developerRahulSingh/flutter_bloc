import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/src/component/transactionDetail.component.dart';
import 'package:fvbank/src/login.page.dart';
import 'package:fvbank/themes/common.theme.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

import 'component/transactionItem.component.dart';

class DashboardPage extends StatefulWidget {
  final String token;

  DashboardPage({
    Key key,
    @required this.token,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  static List<dynamic> userData = [];
  static List<dynamic> accountData = [];

  UserRepository userRepository;

  bool isLoading = false;

  Future<dynamic> fetchUserData() async {
    userRepository.getUserProfile(sessionToken: widget.token).then((value) => {
          setState(() {
            userData.add(value);
          }),
          print("dashboard 1234 ==>> $userData")
        });
  }

  Future<dynamic> fetchAccountDetail() async {
    userRepository.getAccounts(sessionToken: widget.token).then((value) => {
          setState(() {
            accountData.add(value);
          }),
          print("dashboard 5678 ==>> $accountData")
        });
  }

  @override
  void initState() {
    super.initState();
    userRepository = new UserRepository();

    fetchUserData();
    fetchAccountDetail();
  }

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

  Future<dynamic> _getTransactionDetailAPI(
      String sessionToken, String transactionNumber) async {
    try {
      Map<String, String> headers = {
        'session-token': sessionToken,
        'accept': 'application/json',
        'channel': 'mobile'
      };
      final body = {};
      var uri = Uri.parse(
          'https://dev.backend.fvbank.us/api/transfers/$transactionNumber');
      uri = uri.replace(queryParameters: <String, dynamic>{'fields': []});
      final response = await http.get(uri, headers: headers);

      if (jsonDecode(response.body)['code'] == 'loggedOut' &&
          response.statusCode == 401) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return;
      }
      print('DDDDD:-${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }

  _transactionItemPressed(
      context, int index, dynamic data, String sessionToken) async {
    dynamic transactionNumber = data[index]['transactionNumber'];
    var resTransactionDetails =
        await _getTransactionDetailAPI(sessionToken, transactionNumber);
    print('RES TRANSACTION DETAILS:-$resTransactionDetails');

    String to = '';
    String from = '';
    if (resTransactionDetails['from']['kind'] == 'user') {
      var transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
        String companyName = '';
        String firstName = '';
        String lastName = '';
        if (resTransactionDetails.containsKey('transaction')) {
          var transactionData = resTransactionDetails['transaction'];
          if (transactionData.containsKey('customValues')) {
            var array = resTransactionDetails['transaction']['customValues'];
            for (int i = 0; i < array.length; i++) {
              var singleData = array[i];
              var val = singleData['field']['internalName'];
              if (val == 'Beneficiary_Company_Name') {
                companyName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_First_Name') {
                firstName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_Last_Name') {
                lastName = singleData['stringValue'];
              }
            }
          }
        }

        if (companyName != '') {
          transactionTitle = companyName;
        } else if (firstName != '' || lastName != '') {
          transactionTitle = '$firstName $lastName';
        } else if (companyName == '' || firstName == '' || lastName == '') {
          transactionTitle = resTransactionDetails['to']['type']['name'];
        }
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
      if (transactionTitle != '') {
        to = transactionTitle;
        from = resTransactionDetails['from']['user']['display'];
      }
    } else {
      var transactionTitle = resTransactionDetails['from']['type']['name'];

      String senderName;
      String companyName = '';
      String firstName = '';
      String lastName = '';
      if (resTransactionDetails.containsKey('transaction')) {
        var transactionData = resTransactionDetails['transaction'];
        if (transactionData.containsKey('customValues')) {
          var array = resTransactionDetails['transaction']['customValues'];
          for (int i = 0; i < array.length; i++) {
            var singleData = array[i];
            var val = singleData['field']['internalName'];
            if (val == 'Deposit_Sender') {
              senderName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_Company_Name') {
              companyName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_First_Name') {
              firstName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_Last_Name') {
              lastName = singleData['stringValue'];
            }
          }
        }
      }
      if (senderName != '') {
        transactionTitle = senderName;
      }
      if (companyName != '') {
        transactionTitle = companyName;
      } else if (firstName != '' || lastName != '') {
        transactionTitle = '$firstName $lastName';
      } else if (companyName == '' || firstName == '' || lastName == '') {
        transactionTitle = resTransactionDetails['from']['type']['name'];
      }

      if (transactionTitle != '') {
        to = resTransactionDetails['to']['user']['display'];
        from = transactionTitle;
      }
    }

    String performedBy = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']['by']['display']
        : '';
    String channel = resTransactionDetails.containsKey('transaction')
        ? resTransactionDetails['transaction']['channel']['name']
        : '';
    String description = resTransactionDetails['transaction']['description'];

    dynamic typeName = data[index]['type'];
    DateTime date = DateTime.parse(data[index]['date']);
    final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
    final String formattedDate = formatter.format(date);
    setState(() {
      isLoading = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return TransactionDetailComponent(
            transactionNumber: transactionNumber,
            date: formattedDate,
            amount: data[index]['amount'],
            performedBy: performedBy,
            from: from,
            to: to,
            paymentType: typeName['name'],
            channel: channel,
            description: description == null ? '' : description,
          );
        });
  }

  Future<String> _getName(
      context, int index, dynamic data, String sessionToken) async {
    dynamic resTransactionDetails = await _getTransactionDetailAPI(
        sessionToken, data[index]['transactionNumber']);
    print('RES TRANSACTION DETAILS:-$resTransactionDetails');
    String transactionTitle = '';
    if (resTransactionDetails['from']['kind'] == 'user') {
      transactionTitle = resTransactionDetails['to']['type']['name'];
      if (resTransactionDetails['kind'] == 'payment') {
        String companyName = '';
        String firstName = '';
        String lastName = '';
        if (resTransactionDetails.containsKey('transaction')) {
          var transactionData = resTransactionDetails['transaction'];
          if (transactionData.containsKey('customValues')) {
            var array = resTransactionDetails['transaction']['customValues'];
            for (int i = 0; i < array.length; i++) {
              var singleData = array[i];
              var val = singleData['field']['internalName'];
              if (val == 'Beneficiary_Company_Name') {
                companyName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_First_Name') {
                firstName = singleData['stringValue'];
              }
              if (val == 'Beneficiary_Last_Name') {
                lastName = singleData['stringValue'];
              }
            }
          }
        }

        if (companyName != '') {
          transactionTitle = companyName;
        } else if (firstName != '' || lastName != '') {
          transactionTitle = '$firstName $lastName';
        } else if (companyName == '' || firstName == '' || lastName == '') {
          transactionTitle = resTransactionDetails['to']['type']['name'];
        }
      } else if (resTransactionDetails['kind'] == 'transferFee') {}
    } else {
      transactionTitle = resTransactionDetails['from']['type']['name'];

      String senderName;
      String companyName = '';
      String firstName = '';
      String lastName = '';
      if (resTransactionDetails.containsKey('transaction')) {
        var transactionData = resTransactionDetails['transaction'];
        if (transactionData.containsKey('customValues')) {
          var array = resTransactionDetails['transaction']['customValues'];
          for (int i = 0; i < array.length; i++) {
            var singleData = array[i];
            var val = singleData['field']['internalName'];
            if (val == 'Deposit_Sender') {
              senderName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_Company_Name') {
              companyName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_First_Name') {
              firstName = singleData['stringValue'];
            }
            if (val == 'Beneficiary_Last_Name') {
              lastName = singleData['stringValue'];
            }
          }
        }
      }
      if (senderName != '') {
        transactionTitle = senderName;
      }
      if (companyName != '') {
        transactionTitle = companyName;
      } else if (firstName != '' || lastName != '') {
        transactionTitle = '$firstName $lastName';
      } else if (companyName == '' || firstName == '' || lastName == '') {
        transactionTitle = resTransactionDetails['from']['type']['name'];
      }
    }
    return transactionTitle;
  }

  dynamic _listItem(dynamic historyListData, String sessionToken) {
    if (historyListData.length > 0) {
      return Container(
        child: ListView.separated(
            shrinkWrap: true,
            itemCount: historyListData.length,
            itemBuilder: (BuildContext context, int index) {
              dynamic typeName = historyListData[index]['type'];
              DateTime date = DateTime.parse(historyListData[index]['date']);
              final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
              final String formattedDate = formatter.format(date);
              return GestureDetector(
                child: IntrinsicHeight(
                  child: FutureBuilder<String>(
                      future: _getName(
                          context, index, historyListData, sessionToken),
                      builder: (context, snapshot) {
                        return TransactionItemComponent(
                          companyName: snapshot.hasData ? snapshot.data : '--',
                          dateTime: formattedDate,
                          amount: historyListData[index]['amount'],
                          transactionId: historyListData[index]
                              ['transactionNumber'],
                          description: historyListData[index]['description'],
                          imagePath: 'images/icon_bank.png',
                        );
                      }),
                ),
                onTap: () {
                  print('Item Selected:-$index');
                  setState(() {
                    isLoading = true;
                  });
                  _transactionItemPressed(
                      context, index, historyListData, sessionToken);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                )),
      );
    } else {
      return Container(
        color: CommonTheme.COLOR_BRIGHT,
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Loading',
          textAlign: TextAlign.center,
        ),
      );
    }
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
//    print("Return==>> ${userData.length} ");
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CommonTheme.COLOR_PRIMARY,
        body: Stack(
          children: <Widget>[
            SafeArea(
              bottom: false,
              child: Column(
                children: <Widget>[
                  for (var userDetail in userData)
                    for (var accountDetail in accountData)
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              userDetail['display'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CommonTheme.TEXT_SIZE_MEDIUM,
                              ),
                            ),
                            Text(
                              userDetail['group']['name'] + ' Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 27),
                              child: Text(
                                'Current Balance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: CommonTheme.TEXT_SIZE_SMALL,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                accountDetail['currency']['symbol'] +
                                    ' ' +
                                    accountDetail['status']['availableBalance'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: CommonTheme.TEXT_SIZE_EXTRA_LARGE,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
        ),
      ),
    );
  }
}
