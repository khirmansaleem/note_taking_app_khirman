// CRUD --> create , read, update and delete.
//==============================================================================================================
//---------------------------------SqLite ---------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------
// sqlite is library created in C, that allow us to store data inside a file.
// sqlite is a database engine going to use in our application.
// sqlite database is  a file that sits on the disk, and there is sqlite engine that
// reads from the file and write to it, and this sqlite engine runs on db browser for sqlite
//  or it can bring to terminal.
// we will bring this sqlite engine into flutter application, so our app should talk to the
// database.
//===============================================================================================================
//_________________ DB Browser for sqlite____________________________________________________________________________
//=================================================================================================================
// DB Browser for SQLite (DB4S) is a high quality, visual, open source tool to
// create, design, and edit database files compatible with SQLite.
//==============================================================================
//Primary key is by default unique. which is unique identifier of our table.
// primary key is usually int.
// primary key in user table is unique key using which we can query different
// users from the table.
// auto increment increments id each time when new user generated.
//the difference is that unique key can be null but primary cannot be nul
// and table contains only one primary key
// foreign key whose value is bound to something else other table. and you are
// passing that in this table. user id passed as foreign key to the notes table.
// actually it is primary key in user table.
// foreign key is passed to notes table , to identify each note belong to which
// user.
// =============================================================================
// sqflite --> package for storage of our data. for actual storage and talking
// with our database.
//=====================application document directory=======================================
// where app stores it's persistent data on the user device.
//-------------------------------------------------------------------------------------------
// path provider --> to get app's document's directory for database storage.
//path package gives the full path of the file in the document folder.
// it has a join function.
// path provider, gives the path of the directory, and path package joins path
// with the filename and gives the entire path to that file.
// ----------------------------------------------------------------------------
// when we talk with the database we are gonna need hash tables, for reading every row from that table.
// =============================================================================================================
// ---------------------------------covariant keyword in dart ------------------------------------------------->
// this keyword allows you to change the behavior of input parameters, so they do not necessarily conforms to the
// signature of that parameter in the super class.
// allow the subclass to accept a more specific type of parameter than one defined in the parent class.
// if in parent class, object is passed as parameter --> this can any object.
// but in child class we are specifying the object should be of same class.
// child class can implement more specific behavior while still adhering to the contract in the superclass.
//===============================================================================================================
//----------------------------TRIPLE QUOTATION MARK IN DART--------------------------------------------
//triple quotation marks (either ''' or """) are used to create multi-line strings.
// This allows you to include a string that spans several lines without needing to use
// the newline escape character \n at the end of each line.
//===============================================================================================================
//  when an application is installed, local database associated with this app will be stored in the storage
// of that device.
//in flutter using path and path provider, we are getting the path where that local database file will
// be stored on the user device.
//===============================================================================
// =================================================================================
