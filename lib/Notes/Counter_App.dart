/*

class HomePage extends StatefulWidget {
  const HomePage({super.key});
// we make it stateful widget, because we want text editing controller here.
  //we have a text field for entering any number , and bloc holds onto number
  // create two events increment and decrement.
  // when we given increment event on bloc then we grab current value inside text
  // field, if we start with 0, then add 5 to the text field, then we want 5
  // to be added to current state and result will be 5.

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
        create: (context)=>CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Counter App',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
        ),
        body:
          BlocConsumer<CounterBloc,CounterState>(
            // inside consumer there will be listener, as well as builder.
            listener: (context, state) {
              // whenever receives a new state, clear the text controller
              textController.clear();
            } ,
            builder: (context,state){
              final invalidValue=(state is CounterStateInvalidNumber)?
              state.invalidValue : '';
              //state.invalidValue is the 'invalidValue' of class CounterStateInvalidNumber
              return Column(
               children: [
                  Text('The current value =>  ${state.value}'),
                 Visibility(
                     child: Text('the invalid state is : ${invalidValue}'),
                     visible: state is CounterStateInvalidNumber,
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
                       // in the on press event of button, we will send this increment
                       // event to the bloc
                       context.read<CounterBloc>().add(
                           IncrementEvent(textController.text));
                     },
                       style: TextButton.styleFrom(
                         backgroundColor: Colors.blue, // Background color
                       ),
                         child: const Text('+',style: TextStyle(color: Colors.white),),

                     ),
                    const  SizedBox(width: 20),
                     TextButton(onPressed: (){
                       context.read<CounterBloc>().add
                         (DecrementEvent(textController.text));
                     },
                         style: TextButton.styleFrom(
                           backgroundColor: Colors.blue, // Background color
                         ),
                         child: const Text('-',style: TextStyle(color: Colors.white),))
                   ],
                 )

               ],


              );

            }
            ,

          )
      ),
    );
  }
}
// this is the basic state of the bloc, we are not gonna use this state as it
// is we will create two sub states of this state.
@immutable
abstract class CounterState{
  final int value;

  const CounterState({required this.value});
}
// categorization of valid state and invalid state is becoz input to the text
//field should be integer not any string.
class CounterStateValidNumber extends CounterState{
  // give value to this constant constructor, then it will call it's super class
  // with that value.
 const CounterStateValidNumber(int value): super(value: value);
}
// when you input a invalidValue then it will display previous value.
class CounterStateInvalidNumber extends CounterState{
  final String invalidValue;
  const  CounterStateInvalidNumber({required this.invalidValue,
    required int previousValue}):super(value: previousValue);
}
@immutable
// string that comes from UI goes directly into counter event.
abstract class CounterEvent{
  final String value;

  const CounterEvent({required this.value});
}
// Event is something we need to trigger and send to bloc from UI.
class IncrementEvent extends CounterEvent{
  const IncrementEvent(String value):super(value:value);
}
class DecrementEvent extends CounterEvent{
  const DecrementEvent(String value):super(value:value);
}

class CounterBloc extends Bloc<CounterEvent,CounterState>{
  // super calls the initial state and every bloc has to have initial state.
  CounterBloc():super(const CounterStateValidNumber(0)){
    // grab these events:
    // on function can be used on a bloc
    on <IncrementEvent>((event,emit){
      // parse that string value in IncrementEvent as integer.
      final integer=int.tryParse(event.value);
      if(integer==null){
        // emit new state of the app
        emit(CounterStateInvalidNumber(invalidValue: event.value,
            previousValue: state.value));
      }
      else{
        // state.value --> state will be storing each current value
        // and it will be added to the next value
        // if the value is not null then the current state will be:
        emit(CounterStateValidNumber(state.value+integer));
      }
    });
    on <DecrementEvent>((event,emit){
      // parse that string value in IncrementEvent as integer.
      final integer=int.tryParse(event.value);
      if(integer==null){
        emit(CounterStateInvalidNumber(invalidValue: event.value,
            previousValue: state.value));
      }
      else{
        emit(CounterStateValidNumber(state.value-integer));

      }
    });
  }

}
 */