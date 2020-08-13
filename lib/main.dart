import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fvbank/src/bloc/authentationBloc/authenticationBloc.dart';
import 'package:fvbank/src/bloc/authentationBloc/authenticationEvent.dart';
import 'package:fvbank/src/bloc/authentationBloc/authenticationState.dart';
import 'package:fvbank/src/login.page.dart';
import 'package:fvbank/src/modal/app_state.dart';
import 'package:fvbank/src/utils/security.storage.util.dart';
import 'package:user_repository/user_repository.dart';

//void main() => runApp(MyApp());

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('${cubit.runtimeType} $error $stackTrace');
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  final _initialState =
      AppState(sessionToken: '', userProfileData: {}, accountsData: {});
//  final Store<AppState> _store = Store(reducer, initialState: _initialState);
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted());
      },
      child: MyApp(userRepository: userRepository),
    ),
  );
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  Future<String> getValue() async {
    var isPinSecurityEnable = await SecurityUtil.isPINCodeSecurityEnabled();
    var userSkippedPINSetup =
        await SecurityUtil.readValue('userSkippedPINSetup');
    print('isPinSecurityEnable:-$isPinSecurityEnable');
    print('userSkippedPINSetup:-$userSkippedPINSetup');
    if (isPinSecurityEnable == 'false' && userSkippedPINSetup == 'true') {
      return 'PIN';
    } else {
      return 'Login';
    }
  }

  @override
  Widget build(BuildContext context) {
    var result = getValue();
    return FutureBuilder<String>(
      future: SecurityUtil.isPINCodeSecurityEnabled(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        return MaterialApp(
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return LoginPage(userRepository: userRepository);
//          home: snapshot.data == 'true' ? OTPComponent() : LoginPage(userRepository: userRepository),
            },
          ),
        );
      },
    );
  }
}
