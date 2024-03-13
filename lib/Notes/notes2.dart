// ::=> Build Context::----------------------------------->
//======================================================================
// It represents the position of a widget in the overall app structure,
// it is kind of address that tells flutter where to locate that widget
// in the widget tree.
// allows widgets to access data from their parents. If theme is located
// in the top of widget tree, then other widgets can access it's data like
// color and font styles, based on it's position in the tree.

//=======================================================================
// ::==>Email verification not working------------------------------>
// then try to login using no credentials, then it will contact the firebase,
// then again login with correct credentials, it will work fine then.
// when you have verified user, application is not gonna immediately understand
// you have to login again with the credentials so that the firebase will
// understand that user is verified.
//==========================================================================
//:: ==> Named Routes Vs Anonymous Routes::--------------------------->
//===========================================================================
// Route is the path that starts from a view and ends on a view.
//named routes--> are with unique names in the app's routing table while
// anonymous routes--> are created without name in the app routing table.
// and created inline without a name.
//---------------------------------------------------------------------------
//==============================================================================
// the logs like print statements, when app is added to android phone , they
// are stored in the buffer of the mobile phone and that logs can be accessed
// by anyone.
//---------------------------------------------------------------------
//=============================================================================
// enumeration comparisons are lot easier than using strings and integers
// in the comparison
// enumerations can be directly passed to the switch cases.
//=============================================================================
//Pop Up menu button vs Pop up menu Item::==>
//==============================================================================
// you can use alias for the import so you may not confuse in choosing right
// // import in your project.
//==============================================================================
// dialog return optional boolean, because user can either sometimes can
// click somewhere out of the dialog box, so it will cause the dialog to
// vanish so in that case it will return null.
//==============================================================================
//---->=============== <Push_Name and Remove_Until> ====================------->
//------------------------------------------------------------------------------
// having a screen and pushing another screen on the top of it, like in stack.
// remove until means removing the existing screen push the new one to the screen.
// like when you are logged in to the app, then you are now logged in to the app
// and you no more need the log in screen in the stack, you have moved to the
// main ui screen, then you can remove the login view from the stack becoz there
// is no mean of it to consume memory by sitting in the stack.
// "route"=> false means that remove everything from the screen until there is
// nothing left in the route.

//==============================================================================
//_____________________________________________________________________________
// Handling exceptions other than the firebase auth exceptions.
// objects have a function "toString()" using this they can be converted to the
// strings.
//------------------------------------------------------------------------------
//==============================================================================
//------- UI LOGIC AND BACKEND LOGIC SHOULD BE SEPERATED FROM EACH OTHER
// -----------------------------------------------------------------------------
// Firebase is basically the low level abstraction layer that is providing
// high level information to you.
// Firebase should not be directly mixed with the UI code, it is low level
// compared to the UI code, there should be an abstraction layer between
// the UI and firebase backend, there is always some abstraction layer
// between them.
// Ui will be talking with the Firebase Service , and in return that service
// will be talkng to a provider. and provider will talk to firebase.
//==============================================================================
// Immutable Annotation:::-------------------------------------------------==>
// when an annotation immutable is used with a class means that this class
// and it's subclasses are immutable , they cannot contain a field that change
//it's value in initialation

//==============================================================================
// In dart if you are using (_) to ignore the argument, it is actually not
// ignoring the argument , just passing '_' as the argument.
//-----------------------------------------------------------------------------
//==============================================================================
// =====================> SERVICES AND PROVIDERS <===========================
// ----------------------------------------------------------------------------
//Services are tasks that can run in the background of the application,
// handling various operations without directly interfering with the UI logic.
// Providers are mechanisms that supply these services to different parts of
// the application and manage when and where they are provided, facilitating
// the use of services where needed without coupling the service logic tightly
// to the UI components.
//==========================================================================================
//----------------------------------------------------------------------------------------
//These services encapsulate the logic required to interact with Firebase's features, such
// as authenticating users, sending or receiving messages, and managing notifications,
// thereby separating this logic from the UI components. This approach allows for cleaner,
// more maintainable code and a better separation of concerns within the application.
//=======================================================================================
//--------------------------------------------------------------------------------------