import 'package:fvbank/src/modal/app_state.dart';
import 'package:fvbank/src/redux/actions.dart';

AppState reducer(AppState prevState, dynamic action) {
  AppState newState = AppState.fromAppState(prevState);

  if (action is StoreSessionToken) {
    newState.sessionToken = action.payload;
  } else if (action is StoreUserProfileData) {
    newState.userProfileData = action.payload;
  } else if (action is StoreAccountsData) {
    newState.accountsData = action.payload;
  } else if (action is StoreAccountsHistory) {
    newState.accountsHistory = action.payload;
  }

  return newState;
}
