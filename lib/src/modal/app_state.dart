class AppState {
  String sessionToken;
  dynamic userProfileData;
  dynamic accountsData;
  dynamic accountsHistory;

  AppState(
      {this.sessionToken = '',
      this.userProfileData,
      this.accountsData,
      this.accountsHistory});

  AppState.fromAppState(AppState another) {
    sessionToken = another.sessionToken;
    userProfileData = another.userProfileData;
    accountsData = another.accountsData;
    accountsHistory = another.accountsHistory;
  }

  String get getSessionToken => sessionToken;

  dynamic get getUserProfileData => userProfileData;

  dynamic get getAccountsData => accountsData;

  dynamic get getAccountsHistory => accountsHistory;
}
