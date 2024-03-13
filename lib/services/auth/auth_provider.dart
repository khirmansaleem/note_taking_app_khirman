import 'package:note_taking_app_khirman/services/auth/auth_user.dart';
// this basically includes all the providers like
// facebook, google, email/password using which authentication can be
// done.
// this abstract class dictating the implementation for any authentication
//provider
// we can implement it's method and specify the authentication provider.
// here we want firebaseAuth Provider
abstract class AuthProvider{

  Future<void> initialize();
  // it will contain abstract methods only
  AuthUser? get currentUser;
  // firebase if can't return email or password, it throws an error.

  Future<AuthUser> logIn({
    required String email,
    required String password
});
  Future<AuthUser> createUser({
    required String email,
    required String password
  });
  Future<void> logOut();
  // another function to send us email verification
  Future<void> sendEmailVerification();
}