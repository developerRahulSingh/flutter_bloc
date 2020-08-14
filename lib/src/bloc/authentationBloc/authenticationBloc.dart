import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

import 'authenticationEvent.dart';
import 'authenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
//  final AuthenticationBloc authenticationBloc;
////  AuthenticationBloc authenticationBloc = AuthenticationBloc();
//
//
//  AuthenticationBloc({@required this.authenticationBloc})
////      : assert(authenticationBloc != null), super(null);
//      : super(null);
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(null);

  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {}

    if (event is AuthenticationLoggedIn) {
      yield AuthenticationInProgress();

      yield AuthenticationSuccess(token: event.token);
    }

//    if (event is AuthenticationLoggedOut) {
//      print('AuthenticationBloc ==>> 7');
//
//      // yield AuthenticationInProgress();
//      await userRepository.deleteToken();
//      yield AuthenticationFailure();
//    }
  }
}
