
// inside AuthBlock your job is to handle various events and based on those
// events produce state.
import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:note_taking_app_khirman/services/auth/auth_provider.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_events.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_state.dart';
import 'package:note_taking_app_khirman/services/auth/firebase_auth_provider.dart';
// if there is login failure, then user must be logged out and if there is logout failure
// then user must be logged in.
class AuthBloc extends Bloc<AuthEvents,AuthState>{
  // initial state of bloc will be loading
   AuthBloc(AuthProvider provider): super(const AuthStateUninitialized(
     isLoading: true
   )){
     //.........................................................................
     // send email verification event :
     on<SendEmailVerificationEvent>((event,emit)async{
      await provider.sendEmailVerification();
      // in sendEmail Verfication we are not moving the user to anywhere
      //else, it will remain here,because, it just send email verification
      // and not navigate to other screen.
      emit(state);
       });


     on <RegisterEvent>((event,emit)async{
       final email=event.email;
       final password=event.password;
       try{
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
       }
       catch(e,stackTrace){
         print('Register failed with exception: $e');
         print('StackTrace: $stackTrace');
         emit(AuthStateRegistering(exception: e as Exception,isLoading: false ));
       }
     });


     // initialize event::
     on <InitializeEvent> ((event,emit)async{
      // when user initialize, what we do, we go to the provider and
       // initialize it

      await  provider.initialize();
      final user=provider.currentUser;
      // AFTER initialization if user is null then state will loggedOut
      // if email not verified then state will be need verification
      // if logged in then state will be updated t loggedIn
      if(user==null){
        emit(const AuthStateLoggedOut(exception: null,
            isLoading: false));
      }
      else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification(isLoading:false));
      }
      // in this case user is not null so we can login
      else{
        emit(AuthStateLoggedIn(user: user,isLoading: false));
      }
     });

     // login event
     //.........................................................................
     on <LoginEvent> ((event,emit)async{

       emit(const AuthStateLoggedOut(exception: null,
           isLoading: true,loadingText: 'Please wait while log you in'));
      // this event will give email and password and
       // we will give them to provider
       //grab email and password  from the loginEvent
       // all the async events include this loading state,because they take some
       // time to complete.
     //  emit(const AuthStateLoading());
       final email=event.email;
       final password=event.password;
       // now what states will this login will produce

        try{
       final user= await provider.logIn(email: email, password: password);
       if(!user.isEmailVerified){
         emit(const AuthStateLoggedOut(exception: null,isLoading: false));
         emit(const AuthStateNeedsVerification(isLoading: false));
       }
       else{
         emit(const AuthStateVerified(isLoading: false));
         emit(AuthStateLoggedIn(user: user,isLoading: false));

       }

        }
       catch(e,stackTrace){
         print('Login failed with exception: $e');
         print('StackTrace: $stackTrace');
         emit(AuthStateLoggedOut(exception: e as Exception,
         isLoading: false));
       }

     });
     //logout event
     on <LogoutEvent> ((event,emit)async{
       emit(const AuthStateUninitialized(isLoading: false));
       try{
           await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null,
              isLoading: false));
       }
       on Exception catch(e){
         emit(AuthStateLoggedOut(exception: e,
             isLoading: false));
       }

     });

     on<ShouldRegisterEvent>((event, emit) {
       emit(const AuthStateRegistering(exception: null,isLoading: false));
     });

     on<ForgotPasswordEvent>((event, emit) async{
       // state when just landed onto the Forgot Passowrd screen
       emit(const AuthStateForgotPassword(exception: null,
           hasSentEmail: false, isLoading: false));

       final email=event.email;
       print('testing the Forgot password event');
       print(email);

       if(email==null){
         return;// user just want to visit to this screen
       }
       bool didSendEmail;
       Exception? exception;

         try{
             print('testing inside try block');
             print(email);
           await provider.sendPasswordReset(toEmail: email);
             print(email);

           didSendEmail=true;
           exception=null;
         }

         on Exception catch(e){
           print('inside exception.');
           didSendEmail=false;
           exception=e;
           // all parameters passed to const constructors are compile time constants
           // when you are passing exception, it is identified at run time
           // so it cannot be constant
           // so a constructor containing exception cannot  be const.

         }
       emit(AuthStateForgotPassword(exception:exception, hasSentEmail: didSendEmail,
           isLoading: false));

     });





  }
}