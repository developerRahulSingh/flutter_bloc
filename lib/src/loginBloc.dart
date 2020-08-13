import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

import 'bloc/authentationBloc/authenticationBloc.dart';
import 'bloc/authentationBloc/authenticationEvent.dart';
import 'loginEvent.dart';
import 'loginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        super(null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      print('1');
      yield LoginInProgress();
      try {
        print('2');
        var token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        print("Token ==>> ");
        print(token);
        authenticationBloc.add(AuthenticationLoggedIn(token: token));
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
