import 'package:first_flutter/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState{
  const AuthState();
}

class AuthStateLoading extends AuthState{
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState{
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState{
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogOutFailure extends AuthState{
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}
