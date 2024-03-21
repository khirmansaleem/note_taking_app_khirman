// diff between buffer and cache.
// streams are the sequence of asynchronous events that can be single
// subscription or broadcast subscription.
// in broadcast there can be multiple listeners that listen to that stream
// at the same time.
//=============================================================================
//  some stream types, such as "BehaviorSubject" in the Rx programming paradigm
// , the current value is cached and immediately available to any new subscriber
// or listener the moment they start listening to the stream.
//=============================================================================
// This means that when a new listener starts listening to the stream, it will
// not receive the last value that was emitted before it started listening. In
// other words, it only receives new events/data emitted after it has
// subscribed to the stream.
// Which is the broadcast stream controller, which do not hold on to current value
// to a new listener.
//===============================================================================
// late final, we have a commitment with dart that this instance variable
// will be initialized upon constructing new instance of class.
//---------------------------------------------------------------------------------
//=================================================================================
//noteService is singleton, upon creating one time it should keep it's state
//so we remove dispose function, each time we do hot reload, it closes
//noteService, which in turn closes database as well.
//==============================================================================
// when uninstall app, local database associated with it will also be removed
// from android document directory.
//==============================================================================
// instead of using multiple dialogs for different operation, can be
// consolidated to a single dialog that can be customize for specific
// purposes.
//=================================================================================
//=======================CONCEPT OF CALLBACK FUNCTION IN DART============================
//=================================================================================
//callback function is a function that is passed to another function as a argument,
// and will be executed in the outer function body at certain time. For eg, if a
// onDelete() is passed as callback to outer function, then it will be executed on
// button pressing.
//==================================================================================
//------------------------------------------------------------------------------------------
//=============== GENERIC WAY OF EXTRACTING ARGUMENTS FROM THE BUILD CONTEXT=======
// =====================================================================
// passing arguments when navigate, will require ModalRoute.settings.arguments
// from notesView we have to pass our note to 'createOrUpdateNote()'.
// if we were passed a note as argument to newNoteView then we don't need to
// create a new note, if not then we need to create a note.
// we can also pass arguments of any type between the screens.
//==========================================================================