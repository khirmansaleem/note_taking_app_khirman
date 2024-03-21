//---------------------------------------------------------------------
// Currently we are exposing all the notes to all the users, when
// we log in with different user, it will still display all the notes
// to that user, including notes of other users.
//--------------------------------------------------------------------
// Notes only related to current user should be returned from the stream.
// Current user should be set before actually grabbing the list of notes.
// stream has where associated with it, which contains condition, if that
// condition met then can filter stream based on condition.
//----------------------------------------------------------------------
//================================================================================
// CURRENTLY WE ARE STORING OUR DATA LOCALLY NOT REMOTELY , SO ON UNINSTALLING
//APPLICATION WHICH RESULT IN PERMANENT DATA LOSS.
//----------------------------------------------------------------------

