
//=====================WIDGETS:::=======================================
// ctrl+ . --> to bind code ==>
// ctrl +alt +l --> indent all the code
// ctrl +shift + F --> to search for anything in entire project.
// =============>shift+F6 <============ --> renaming in one go.
// In Flutter, widgets are responsible for creating elements of the UI and
// can contain data that will be displayed on the screen,
// along with specifying how that data is presented and interacted with.
// ===================================================================================================
// This will contain notes related to dart
// firebase cli is the cli to interact with firebase right from our terminal.
// ============ DIFFERENCE BETWEEN HOT RELOAD AND HOT RESTART??===========================
//==> Hot reload:: quickly reflect the changes made in code into the running app without
// needing to restart, it is for ui updates and minor logic changes.
// hot reload conserve the state.
// ctrl +\
// Hot Restart:: Hot restart is needed for more significant changes that affect the
// app state or require re reinitialization. it is middle ground between hot reload
// and full restart. restart your application with new state.
//======================================================================================
// =====================================stateful vs stateless=================== ?
// State is basically data hold within app which is mutated by either user or app
// programmatically.
// stateful widget::=> which keeps hold of the information, upon the change of
// information, it can read /write itself.
// stateful is something visible which contains data on which changing it can
//read/write itself.
// stateful widget --> read/write itself and contain mutable data
// Stateless widgets --> can also read/write depending on the condition but
// they can't contain mutable variables.
//=====================================================================================
// ========================== SCAFFOLD ==============================================
// ==> Scaffold :: in order to make your application presentable to the user,
// scaffold is used. it is the basic building structure of an application that
// make it presentable to average users.
// REGISTER USER TO FIREBASE IS ASYNCHRONOUS : it will not be immediately
//completed, tell flutter that button press is asynchronous task.
// Firebase has the concept of anonymous user, if there is no user then it
// is not null, it is anonymous.
//------------------------------------------------------------------------
// ==>::Column widget:: is used for stacking components vertically.
//------------------------------------------------------------------------
//::Text Editing Controllers:: proxy objects that you passed to your text
//field and textfield write all the time to that controller,
// it is acting as proxy that is grabbing information from textfield and
// button is reading that information.
//-----------------------------------------------------------------------
// use of late final is a contract that it will be initialized before
// first use.
//==========================================================================
//==> Stateful widget has 2 functions:========>
//init state: called automatically when create homepage in this app.
// dispose : when homepage dies out of the memory and finished, then
// a function disposed is called.
//-------------------------------------------------------------------------
// ==> Widgets Flutter Bindings:::=========>
// firebase needs to kickstart it's process before everything is rendered
// on the screen. for this it needs core flutter engine to be in place.
// so it can make call to core flutter engine that i am done,
// for this we need widget flutter binding
//
//--------------------------------------------------------------------------
//===>Future BUIlder::::============>>>>
// it takes the future and performs the future, once the future has been
// succeeded or failed, it gives callback in which it asks you produce a  widget
// you want to display to the user, depending on the state of the future
// resolved.
// instead you having to do the initialization of firebase everytime user
// presses the button, I am not gonna do anything until that is done
// once that is done or errors out, let me know i will give you a widget
// depending on the result.
//-------------------------------------------------------------------------
// ::Connection States::
// async snapshot of an object is the state of an object,
// object is basically the result of future
// connection states to determine the state of the future.
// if the connection with the firebase is done,then only it will render column to
// the screen otherwise it will just display loading
//----------------------------------------------------------------------------
//=============UNDERSTANDING ABOUT GIT==============================================
// your code need to be stored on a secure place , which is repository in github.
// Use 2 services: git and github for storing your code on safe place and
// retrieve it later on.
// git is a software on your computer that allow you to manage various changes
// made to codebase, keeping track of date on which those changes were made,
// person who made changes and changes themselves
// also gives difference between recent changes and what was already commited in
// your github repository.
// commit--> make promise changes to the code.
//Tracked and untracked files ::::
// track file that you have the git about before, it is tracking the changes made to it
// untrack file ---> git is not aware.
// Stagged file ---> that is to be commited but not commited yet.
//--------------------------------------------------------------------------
// Push a screen means when you are open a new screen on top of existing
// screen.
//--------------------------------------------------------------------------------