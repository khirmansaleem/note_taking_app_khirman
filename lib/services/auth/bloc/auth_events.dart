import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvents{
  const AuthEvents();
}

class InitializeEvent extends AuthEvents{
  // this event has one state which is "AuthStateLoading"
  const InitializeEvent();
}

class LoginEvent extends AuthEvents{
  // login event has following states.
  // AuthStateLoggedIn, AuthStateLoginFailure, AuthStateNeedsVerification
  final String email;
  final String password;
 const LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthEvents{
  // logout event has 2 states
  // AuthStateLoggedOut and AuthStateLogoutFailure.
  const LogoutEvent();
}
class SendEmailVerificationEvent extends AuthEvents{
const SendEmailVerificationEvent();
}

class RegisterEvent extends AuthEvents{
  final String email;
  final String password;

 const  RegisterEvent({required this.email, required this.password});
}
// in the login view when you click on "Not Register yet, click here to register'
// then you need this event there.
class ShouldRegisterEvent extends AuthEvents{
  const ShouldRegisterEvent();
}

class ForgotPasswordEvent extends AuthEvents{
  final String? email;
 const ForgotPasswordEvent({required this.email});

}