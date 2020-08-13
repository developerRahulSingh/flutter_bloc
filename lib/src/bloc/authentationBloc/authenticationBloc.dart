import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

import 'authenticationEvent.dart';
import 'authenticationState.dart';

class  AuthenticationBloc
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
    print('AuthenticationBloc ==>> 0');
    if (event is AuthenticationStarted) {
      print('AuthenticationBloc ==>> 1');
    }
    print('AuthenticationBloc ==>> 2');

    if (event is AuthenticationLoggedIn) {
      print('AuthenticationBloc ==>> 3');

      yield AuthenticationInProgress();
      print('AuthenticationBloc ==>> 4');

      yield AuthenticationSuccess(displayName: event.token);
      print('AuthenticationBloc ==>> 5');
    }
    print('AuthenticationBloc ==>> 6');

//    if (event is AuthenticationLoggedOut) {
//      print('AuthenticationBloc ==>> 7');
//
//      // yield AuthenticationInProgress();
//      await userRepository.deleteToken();
//      yield AuthenticationFailure();
//    }
  }
}
