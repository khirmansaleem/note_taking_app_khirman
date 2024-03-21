import 'package:firebase_core/firebase_core.dart';
import 'package:note_taking_app_khirman/firebase_options.dart';
import 'package:note_taking_app_khirman/services/auth/auth_provider.dart';
import 'package:note_taking_app_khirman/services/auth/auth_user.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
show FirebaseAuth,FirebaseAuthException;

// this is concrete implementation of auth_provider class

class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser({required String email,
    required String password}) async{
    try{
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
          password: password);
      final user=currentUser;
      if(user!=null){
        return user;
      }
      else{
        throw UserNotLoggedInAuthException();
      }

    }
    on FirebaseAuthException catch(e){
      switch(e.code){
        case 'invalid-email':
        throw InvalidEmailAuthException();
        case 'weak-password' :
        throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        default:
          throw GenericAuthException();

      }
    }
    catch(_){
      throw GenericAuthException();

    }

  }

  @override
  AuthUser? get currentUser {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      return AuthUser.fromFirebase(user);
    }
    else{
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({required String email,
    required String password,}) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
          password: password);
      final user=currentUser;
      if(user!=null){
        return user;
      }
      else {
        throw UserNotLoggedInAuthException();
      }

    }
    on FirebaseAuthException catch(e){

      switch (e.code) {
        case 'invalid-credential':
         throw InvalidCredentialsAuthException();
          //  Fluttertoast.showToast(msg: "Invalid credentials. Please check your email and password.");

        default:
         throw GenericAuthException();
      }
    }
    catch(_){
      throw GenericAuthException();

    }
  }

  @override
  Future<void> logOut()async {
    final user=FirebaseAuth.instance.currentUser;

    if(user!=null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedInAuthException();
    }

  }

  @override
  Future<void> sendEmailVerification() async{
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.sendEmailVerification();
    }
    else throw UserNotLoggedInAuthException();
    }

  @override
  Future<void> initialize() async{
   await  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  }


