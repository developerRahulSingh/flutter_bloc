import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String token;

  AuthenticationSuccess({this.token = ''});

  @override
  List<Object> get props => [token];

//  @override
//  String toString() => 'Authenticated { displayName: $displayName }';
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}