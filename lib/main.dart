import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/views/loginview.dart';
import 'package:note_taking_app_khirman/views/registerview.dart';
import 'firebase_options.dart';

void main() {
  // for firebase to be initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
      // future passed to the futureBuilder is the firebase
      //initialization.
      future: Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    builder: (context, snapshot){
    switch (snapshot.connectionState) {
    case ConnectionState.done:
      final user=FirebaseAuth.instance.currentUser;// it gives us the logged in user
      //in the firebase.
      if(user?.emailVerified ?? false){
        print("user email is verified");
        return const Text("Verification done");
      }
      else{
        print("Verify your email please.");
        //".addPostFrameCallback()"--> it defers the navigation process until the build
        // method completes, navigation not interfering with build process
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VerifyEmailView()),);
        });// push a widget on the screen
      }
      return const Text('Connection is done');

    default:
    return const Text('Loading......');
    }
    }
    ),
  );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: const Text("Verify Email",
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align items along the main axis
          children: [
            const Text('Please verify your email.'),
            TextButton(
              onPressed: () async{
                final user=FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
              ),
              child: const Text('Send email verification',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),

    );
  }
}
