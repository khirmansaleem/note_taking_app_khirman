//------------------------------ notes service -------------------------------------------------
// -------------------------- UNDERSTANDING STREAMS -------------------------------------------------------
//============================================================================================
// stream and stream controllers in notes service will be used to cache data.
//-------------------------------------------------------------------------------------------
// ================================> In reactive programming  <====================================================-----------------------------
// you have bunch of data sitting somewhere and then you performs operations
// on that data. data will be updated and you will be notified about these updations through
// some pipe of information.
//--------------------------------------------------------------------------------------------------
// Stream is an entity that controls data, keeps hold of data and it has a timeline, starts at some time,
// manipulates data either completes , dies out or keep living on.
// Stream is just the pipes of data that can be manipulated or can be performed operations on it.
//=======================  Stream Controller  ========================================================
// stream controller is interface to stream.
// you usually do not usually add or get stuff from stream directly, you can do is to use stream controller,
// for this purpose.
// Stream controller is responsible for adding stuff to the stream, and reading stuff from the stream.
// so it can be supposed as the manager of the stream.
//============================================================================================================
// in the initial implementation, note service is directly talking with the database, it did not had any
// way to cache those notes, so for that purpose streams were introduced.
// in case of larger databases when there are millions of records, it is not good practice to go to the
// database each time and read the entire thing to just delete one row.
// these operations should be cached in your application before you just go and hit database.
// Interface between UI and note service will be the stream.
//============================================================================================================
// caching the list of notes, note service to expose a list of notes that the ui can then render on the screen.
// when user click add button it will send message to createNote of noteservice where that createNote will
// manipulate the list of notes inside notes service, and then UI will listen to the list of these notes in
// the notesService, if things changes in the list, then UI will automatically updated with those changes.
//=============================================================================================================
//=========================================================================================================
//==========================>Main idea behind use of streams<==============================================
//=============================================================================================================
// ------------------------------------- Broadcast In streams ------------------------------------------------------------
// broadcast in streams means once you have listened to the stream once, you can also listen, when changes are
// made to that stream.
//==============================================================================================================
// in case of read operations use of cache can reduce latency.
// Ui reflects current state of notes.
// after deleting an item, ui will be listening to stream and stream contains  updated noteslist,
// so any changes made to the list, updated list  will be directly updated to ui without latency.
//==============================================================================================================
// when user logged in to notesView for first time, then it should be created in the local database as well.
//==============================================================================================================
//========================== Null assert operator ========================================================
//-------------------------------------------------------------------------------------------------------------
//user!.email--> user is nullable but you are asserting that it is not null, that it will always return some
// value.
//==========================================================================================================
//-------------------------------FUTURE BUILDER-----------------------------------
// future builder subscribe to a future which returns it's value in the future,
// based on the value of future, builder will return various widgets.
// it ties your future logic with the ui logic.
// future subscribes itself to the value returned by getOrCreateUser()
// and tells us various updates which are async snapshots, based onn
// those updates some widget will be displayed.
//=================================================================================================
// ===========================Stream Builder ========================================================
//==================================================================================================
// retrieve all the notes from the note service and render them on the screen.
// Stream builder listen to the changes made to the stream.
//-------------------------------------------------------------------------------------
// ========================== Waiting and done flags in Connection state =====================================
// both future builder and stream builder work with async snapshot, and this async
// snapshot has various connection states,
// Waiting flag--> used when waiting for stream or future.
// done flag--> is used for future that has completed it's task.
// in case of stream, it keeps living so you should not hook into done flag.
// snapshot represents the latest data received from a future or stream.
//------------------------------------------------------------------------------------------------------------
//========================> Singleton and Why we need it in our notesView? <==================================
//============================================================================================================
// in the initState of app, we were creating a new instance of noteService each time.
// Singleton is a pattern used in software development, where you create a class
// instance and that will be only one inside entire application.
// we want to make noteService as singleton, there will be only one copy of this note
// service and not create new instance each time.
// for managing resources that are expensive to create every time,
// for consistent state of a service across the whole application.

//------------------------------------------------------------------------------------------------
//====================================================================================================
