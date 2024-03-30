import 'package:note_taking_app_khirman/services/auth/auth_user.dart';
import 'package:note_taking_app_khirman/services/auth/auth_provider.dart';
import 'package:note_taking_app_khirman/services/auth/firebase_auth_provider.dart';
import 'package:equatable/equatable.dart';
// auth service that implements the auth provider.
// auth service relays the messages of given auth provider, but can have more
// logic.
// it takes the functionalities of the auth provider and expose them to the
// UI Logic.
// everytime we are using auth service, we have to everytime provide it with
// auth provider, --> which is the firebase auth provider,
// but we dont want this situation
//==============================================================================
class AuthService implements AuthProvider{
  final AuthProvider provider;
  // the responsibility of firebase factory on auth service is to return an instance
  // of auth service that is already configured with firebase auth provider
  const AuthService(this.provider);
  factory AuthService.firebase()=>AuthService(FirebaseAuthProvider());
  @override

  Future<AuthUser> createUser({required String email, required String password})=>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password})=>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut()=> provider.logOut();

  @override
  Future<void> sendEmailVerification()=> provider.sendEmailVerification();

  @override
  Future<void> initialize()=> provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail})=>
      provider.sendPasswordReset(toEmail: toEmail);


}