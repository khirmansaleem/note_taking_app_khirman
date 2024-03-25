import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/views/loginview.dart';
import 'package:note_taking_app_khirman/views/notes/create_update_noteview.dart';
import 'package:note_taking_app_khirman/views/registerview.dart';
import 'package:note_taking_app_khirman/views/verifyemailview.dart';
import 'package:note_taking_app_khirman/views/notes/notesview.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
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
    routes: {
       loginRoute: (context) => const LoginView(),
      registerRoute : (context)=> const RegisterView(),
      emailVerRoute :(context)=> const VerifyEmailView(),
      notesRoute :(context)=> const NotesView(),
      createOrUpdateNotesRoute: (context)=> const CreateUpdateNotesView(),
    },
  ));
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 late final TextEditingController textController;
  @override
  void initState() {
    textController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context)=>CounterBloc()
    ,
    child: Scaffold(
    appBar: AppBar(
    title: const Text('Counter App',style: TextStyle(color: Colors.white),),
    backgroundColor: Colors.blue,
    ),
    body: BlocConsumer<CounterBloc,CounterState>(
    listener: (context,state){
    textController.clear();
    }
    , builder: (context,state){
    final invalidValue=(state is InvalidNumberState)?
    state.currentValue : '';
    return Column(
      children: [
        Text('the current value is ${state.value}'),
        Visibility(
            child: Text('invalid Value: $invalidValue'),
          visible: state is InvalidNumberState,
        )
        ,
        TextField(
          controller: textController,
          decoration: const InputDecoration(
              hintText: 'Enter a number here '
          ),
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
         TextButton(onPressed: (){
           context.read<CounterBloc>().add(IncrementEvent(value1: textController.text));
         }
             , child: const Text('+')),
            TextButton(onPressed: (){
              context.read<CounterBloc>().add(DecrementEvent(value1: textController.text));

            }
                , child: const Text('-')),
          ],
        )
       
      ],


    );

    }
    )
    ));
    }
  }

@immutable
 abstract class CounterState{
   final int value;
 const CounterState({required this.value});
}
class InvalidNumberState extends CounterState {
  final String currentValue;
  final int previousValue;

  const InvalidNumberState({required this.currentValue,
    required this.previousValue}) :super(value: previousValue);
}
class ValidNumberState extends CounterState{
  final int value1;
  const ValidNumberState({required this.value1}):super(value: value1);
}

// Now events for the counter :
@immutable
abstract class CounterEvents{
  final String value;
 const CounterEvents({required this.value});
}

class IncrementEvent extends CounterEvents{
  final String value1;
 const IncrementEvent({required this.value1}):super(value: value1);

}
class DecrementEvent extends CounterEvents{
  final String value1;
  const DecrementEvent({required this.value1}):super(value: value1);

}

// Now defining the bloc:
class CounterBloc extends Bloc<CounterEvents,CounterState>{
  CounterBloc(): super(const ValidNumberState(value1: 0)){
    // increment and decrement inside constructor body
    on <IncrementEvent>((event,emit){
      final num= int.tryParse(event.value1);
      if(num==null){
        emit(InvalidNumberState(currentValue:event.value1,
            previousValue: state.value));
      }
      else{
        emit(ValidNumberState(value1: state.value+num));
      }

    });
    on <DecrementEvent>((event,emit){
      final num= int.tryParse(event.value1);
      if(num==null){
        emit(InvalidNumberState(currentValue:event.value1,
            previousValue: state.value));
      }
      else{
        emit(ValidNumberState(value1: state.value-num));
      }
    });
  }

}


/*
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
      // future passed to the futureBuilder is the firebase
      //initialization.
      future:AuthService.firebase().initialize(),
    builder: (context, snapshot){
    switch (snapshot.connectionState) {
    case ConnectionState.done:
      final user=AuthService.firebase().currentUser;// it gives us the logged in user
      //in the firebase.
      if(user!=null) {// user is logged in, current user not null
        if (!user.isEmailVerified) {
          return const VerifyEmailView();
        }
        else{
          return const NotesView();
        }
      }
      else {
        return const LoginView();
      }


    default:
    return const CircularProgressIndicator();
    }
    }

  );
  }
}

*/
