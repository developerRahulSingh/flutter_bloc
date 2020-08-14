import 'dart:async';

import 'package:meta/meta.dart';
import 'package:user_repository/src/interfaces/api_interfaces.dart';

class UserRepository {
  String sessionToken = "";
  String accountType = "";

// Login and get sessionToken
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var res = await APIInterfaces.loginUser(username, password);
    print('RES:-$res');
    sessionToken = res['sessionToken'];
    return sessionToken;
  }

// Get UserProfile Data
 Future<dynamic> getUserProfile({@required String sessionToken}) async {
    var res = await APIInterfaces.getUserProfile(sessionToken);
    return res;
  }

// Get Account Data
  Future<dynamic> getAccounts({@required String sessionToken}) async {
    var resAccounts = await APIInterfaces.getAccounts(sessionToken);
    var accountData = resAccounts[0];
//    accountType = resAccounts[0]['type']['internalName'];
////    print('AccountType ==>> $accountType');
//    print('RES GET ACCOUNTS:-$accountData');
    return accountData;
  }

// Get Account Data
  Future<dynamic> getAccountsHistory() async {
    var resAccountsHistory =
        await APIInterfaces.getAccountsHistory(sessionToken, accountType);
    return resAccountsHistory;
  }
}
