import 'dart:async';

import 'package:meta/meta.dart';
import 'package:user_repository/src/interfaces/api_interfaces.dart';

class UserRepository {
  String sessionToken = "";

// Login and get sessionToken
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var res = await APIInterfaces.loginUser(username, password);
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
    return accountData;
  }

// Get Account Data
  Future<dynamic> getAccountsHistory(
      {@required String sessionToken, @required String accountType}) async {
    var resAccountsHistory =
        await APIInterfaces.getAccountsHistory(sessionToken, accountType);
    return resAccountsHistory;
  }

// Get Transaction Detail
  Future<dynamic> getTransactionDetail(
      {@required String sessionToken,
      @required String transactionNumber}) async {
    var resTransactionDetail = await APIInterfaces.getTransactionDetail(
        sessionToken, transactionNumber);
    return resTransactionDetail;
  }
}
