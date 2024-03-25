/*
Cubit ------------------------------->
is a class that extends bloc base and can be extended to  manage any type of
state.
-->cubit can provide functions and expose them to trigger state changes.
--> UI components will be notified about states and redraw themselves based
on the current state.
input to cubit--> functions
output --> states.
-----------------------------------------------------------------------
Business logic ------------------------->
defines how app behaves in various scenarios, like
unauthenticated user cannot access notes.
--> rules and procedures that how application should behave to different
scenarios.
-------------------------------------------------------------------------
// What is Bloc and why do we need it?
--> it allows you to separate business logic from the presentation of the
application.
// our existing UI code is very much aware of the business logic like when
we create a new note then it require, the current user of the app.
so our ui is exposed to the business logic of application.
-----------------------------------------------------------------------------
BLOC-------------------------------------------->
it is a third party library, created by vgv, internally this bloc library
is using the streams , streams controllers and futures.
we want to make sure that our Ui is only taking care of presentation and
moving rest of the logic to business logic layer.
// this library allow you to pass data from here to there and listeners for
listening to changes in stream.

--------------------------------------------------------------------------------
Flutter Bloc-------------------------------------->
set of specific flutter bloc codes that help us creating widgets.
in order to glue the business logic with UI it needs to be able to
work with flutter.
the library has two parts, one is
bloc--> which works with business logic and dart.
flutter bloc--> that works with UI and help in binding Ui with business logic.
--------------------------------------------------------------------------------
Bloc class----------------------------------------->
the core of bloc library.
--> bloc class is a container, you can add events to this class and every added
event contains a state.
//  it's output is always a state.
// input to this class are events.
// it takes events like login with email and password, register with email and
password, here is my email recover my password, these will be events given as input
to the bloc.
// then the bloc internally analyzes what was the state before, what is current
event and it  produce the new state.
................................................................................
--> Bloc Provider ------------------------------->
it is flutter widget which provides bloc to it's children.
create a bloc instance and provide it to you.
it can be used when you want to subclass the bloc class by creating an instance
of it.
--> Bloc Listener ------------------------------->
that react to changes in your bloc.
--> listen to changes to the states of a bloc.
--> using bloc listener as a reaction you can display error message or navigate
to other screen in respond to changes.
-------------------------------------------------------------------------------
-->BlocBuilder ------------------------------------>
uses your bloc state changes and provide you with a widget.
As you have bloc provider that creates a child of bloc, inside that child you can
create a blocBuilder that listens to changes inside your bloc and it allows you
to create new widgets based on those changes.
--> it is very much like future builder or stream builder.
--------------------------------------------------------------------------------
--> BlocConsumer------------------------------------->
combines blocListener and blocBuilder.
it listens to changes happen inside a block and then it allow you to do side effects
like displaying new screen or error message and also allow you to display new
widget on the screen.
--------------------------------------------------------------------------------
// every bloc has 2 imp properties ::
// state and event.
// event goes into the block and state comes out of the block
state describes the state of the bloc.
---------------------------------------------------------------------------------------
so in case of counter application what we expect from our bloc is to return a state a
as integer or state wrap around an integer.
---------------------------------------------------------------------------------------
TryParse----------------------------------->
-------------------------------------------------------------------------------------
it tries to parse any datatype to integer, if it fails to do so then it will return
a integer which will be null.
...................................................................................
Emit()-->
is a function that allows you to pass your state out of the bloc, when you call emit
to a new state then bloc broadcast this state to the listener.
...................................................................................
given an increment event where value could not be parsed as integer, then emit the
invalidNumberState which will be previous value.
-------------------------------------------------------------------------------------
In the current scenario of counter app, there is need of bloc consumer becoz every time
we presses increment or decrement, text field will be cleared, that is the side effect
like when a new state is coming clear the text field that is the listener, and also
the blocBuilder is needed we want to build the UI based on the current state of the
bloc.
when you need bloc listener and bloc builder at the same level then you can use bloc
consumer for that purpose.
.....................................................................................
--> Visibility widget --------->
this widget is basically responsible for show or hide a widget based on the boolean
flag.
....................................................................................
Immutable class-->
once the instance of class is created, it's state, the values of it's fields and
properties cannot be changed. means all of instance variables must be declared as
final.
...................................................................................

 */
