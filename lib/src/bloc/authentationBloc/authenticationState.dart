import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String displayName;

  AuthenticationSuccess({this.displayName = ''});

  @override
  List<Object> get props => [displayName];

//  @override
//  String toString() => 'Authenticated { displayName: $displayName }';
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}