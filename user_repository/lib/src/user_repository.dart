import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    Map<String, String> headers = {
      'authorization': basicAuth,
      'accept': 'application/json',
      'channel': 'mobile'
    };
    final body = {};
    var uri = Uri.parse('https://dev.backend.fvbank.us/api/auth/session');
    uri = uri
        .replace(queryParameters: <String, String>{'fields': 'sessionToken'});
    final response = await http.post(uri, headers: headers, body: body);
    print('Api call ==>> ');
    print(response.statusCode);
    var av = json.decode(response.body);
    print(av['sessionToken']);
    return av['sessionToken'];
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
