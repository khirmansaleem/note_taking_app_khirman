import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:note_taking_app_khirman/services/auth/auth_provider.dart';
import 'package:note_taking_app_khirman/services/auth/auth_user.dart';
//----------------------------------------------------------------------------------------------------------
// mock authentication provider to test the authentication service
// if we call any function like create user and other without initializing the provider then it should throw
// exception and exception should be defined in the code.
//-----------------------------------------------------------------------------------------------------------
void main(){
 group('Mock Authentication', () { // similar tests, that can run as one unit
   final provider=MockAuthProvider();
   // we are going to run a test on the initialize field , it should be false when initially run it
   test('should not be initialized before starting!', (){
     expect(provider._isInitialized, false);
   });
   test('should be initialized before logging out!',(){ // expect the logout to throw an exception when not
     // initialized
     expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedException>()));
   });
   test('should be able to initialized', ()async{
     await provider.initialize();
     expect(provider._isInitialized, true);
   });
   test('User should be null after initialization', (){
     // expect the current user to be null right after initialization
     expect(provider.currentUser,null);
   });
   test('should be able to initialize in less than 2 seconds', ()async{
     await provider.initialize();
     expect(provider._isInitialized, true);
   },timeout:const Timeout(Duration(seconds: 2)));
   test('Create User should delegate to Login',()async{
   final badEmailUser= provider.createUser(email: 'abc1@gmail.com',
       password: '123456');
   expect(badEmailUser, throwsA(const TypeMatcher<InvalidCredentialsAuthException>()));
   // if we create the user with following credentials then it should be assigned as the current
   // user of the auth provider
   final user=await provider.createUser(email: 'foo', password: 'bar');
   expect( provider.currentUser,user);
   // email verified should set to false before sending email verification
   expect(user.isEmailVerified,false);
   provider.sendEmailVerification();
   final user2=provider.currentUser;
   expect(user2?.isEmailVerified,true);
   });
   test('logged In user should be able to get verified', (){
     final user2=provider.currentUser;
     expect(user2, isNotNull);
   });
   test('allow the user to log out and log in again with new credentials',()async{
     await provider.logOut();
     await provider.logIn(email: 'email', password: 'password');
     final user=provider.currentUser;
     expect(user, isNotNull);
   });
 });


}
class NotInitializedException implements Exception {

}
class MockAuthProvider implements AuthProvider{
  AuthUser? _user; // firebase keeps track of current user itself , we can mock that functionality here.
  var _isInitialized=false; // keep track of initialization

  bool get isInitialized=>_isInitialized;

  @override
  Future<AuthUser> createUser({required String email,
    required String password}) async{
    // in the mock implementation of create user . first, check if the user is initialized, if not throw exception
    // then it do mock fake 1 seconds delay and return user
    // and the user which is returned is login user as well.
  if(!isInitialized) throw NotInitializedException();
  await Future.delayed(const Duration(seconds: 1)); // delay for faking the user creation for testing purpose
   // create user actually log in that user as well.
   return logIn(email: email, password: password);


  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized=true;
  }

  @override
  Future<AuthUser> logIn({required String email,
    required String password,}) {
    if(!isInitialized) throw NotInitializedException();
    if(email=='abc1@gmail.com') throw InvalidCredentialsAuthException();
    if(password=='abc123') throw InvalidCredentialsAuthException();
    const user= AuthUser(isEmailVerified: false);
    _user=user;
    return Future.value(user);
  }

  @override
  Future<void> logOut()async {
    // in logout it checks whether it is initialized, if so then if user is null, if it is then throw
    // exception , and in the end set the user to null for mocking the logging out functionality
    if(!isInitialized) throw NotInitializedException();
    if(_user==null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user=null;


  }

  @override
  Future<void> sendEmailVerification()async {
    if(!isInitialized) throw NotInitializedException();
    final user=_user;
    if(user==null) throw UserNotLoggedInAuthException();
    const newUser=AuthUser(isEmailVerified: true);
    _user=newUser;
  }

}