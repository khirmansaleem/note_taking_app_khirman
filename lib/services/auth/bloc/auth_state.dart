import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app_khirman/services/auth/auth_user.dart';

@immutable
abstract class AuthState{
  final bool isLoading;
  final String? loadingText;

  const AuthState({required this.isLoading, this.loadingText='please wait a moment'});

}

class AuthStateUninitialized extends AuthState{
  // Auth state loading will be used when initializing firebase and when
// login button is pressed, also then communicating with firebase, so state
// will be loading
  const AuthStateUninitialized({required bool isLoading}):super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState{
  // when user is logged in to the application, then it can be used.
// fetching the current user from AuthState instead of AuthService
// to have a layer between service and presentation layer.
// AuthUser will be defined in AuthState.
 final  AuthUser user;
 const  AuthStateLoggedIn({required this.user,required bool isLoading})
 : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState{
  const AuthStateNeedsVerification({required bool isLoading}):
        super(isLoading:isLoading );
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  // logged out with exception null , loading false.
  // logged out with exception null and loading true,
  // logged out with exception e and loading false.
  // 3 different states of the same class.
  final Exception? exception;
  final bool isLoading;

 const AuthStateLoggedOut({required this.exception,
   required this.isLoading,
   String? loadingText
 }):
  super(isLoading: isLoading,loadingText: loadingText);
// we need to create 3 different mutations of same class, so they should be distinguishable from each other.
  @override
  // group of properties taken into account that equatable package calculates.
  List<Object?> get props => [ exception , isLoading ];

}


class AuthStateRegistering extends AuthState{
  final Exception? exception;
  const  AuthStateRegistering({required this.exception,
    required bool isLoading
  }):super(isLoading: isLoading);
}

class AuthStateVerified extends AuthState{
  const AuthStateVerified({required bool isLoading}):
      super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState{
  //either user has just landed, no error nothing, not clicked yet
  // or there is exception when send reminder email , that email is not sent
  // or the email is sent successfully
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({required this.exception, required this.hasSentEmail,
    required bool isLoading}):
        super(isLoading: isLoading);

}