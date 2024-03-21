//==========================================================================
//==========================NOSQL Database=====================================
//==========================================================================
// it is a type of database that is used to store, manage and retrieve data
// using variety of data models other than traditional table based structure
// in relational database,
// for handling large volume of unstructured data, scalability, flexibility
// and high performance,
// document oriented databases in which object is document. it has unique
// identifier key and set of key:value pairs.
//=========================================================================
/*
Collection: users
Document ID: user123
Key-Value Pairs:
name: "Jane Doe"
email: "jane@example.com"
age: 30
 */
//===============================================================================
// ============================CLOUD FIRESTORE====================================
//-------------------------------------------------------------------------------------
//Following Cloud Firestore's NoSQL data model,you store data in documents
// that contain fields mapping to values
//These documents are stored in collections, which are containers for your
// documents that you can use to organize your data and build queries
// Document -->unit of storage, light weight record that contain fields which
//map to values.
// collections--> containers for documents.
// COLLECTION -->DOCUMENTS -->FIELDS THAT ARE MAPPED TO VALUES.
// IN FIRESTORE THERE ARE COLLECTION OF DOCUMENTS WHILE IN CASE OF
// REALTIME DATABASE THERE IS ONE LARGE JSON TREE.
//==============================================================================
//=================Production vs Test Mode====================================
//============================================================================
// there are different ways for a developer to interact with firebase database.
//  in test mode, while developing app you can access the database without
// authentication.
// in Production mode, you add certain rules to the database, so unauthenticated
// access to the database will be denied.
// test mode is looser in terms of security where the production mode is
// tighter.
//===============================================================================
//==============================================================================
// security rules in firestore will impose certain rules on the firestore
// database access.
//These rules allow you to control read, write, and query operations based
// on authentication status, user identities, and the structure of your data.
//===============================================================================
//so it will be defined in the firestore security rules that certain notes will
// be visible to  certain user.
//===============================================================================
// Production mode:::==========================================================>
//Your data is private by default. Client read/write access will only be granted
// as specified by your security rules.
//Test Mode:::=================================================================>
//Your data is open by default to enable quick setup. However, you must update
// your security rules within 30 days to enable long-term client read/write access.
//=================================================================================
// we allow firestore to work in test mode for now , later on we can tighten this
//up.
//----------------------------------------------------------------------------------
// users having valid firebase user when interact with database are allowed to
// read/ write the database.
//================================================================================
//=================================================================================
//COLLECTION is group of related objects, objects can be tables,
// coleection :notes
// then having documents for each note.
// Documents are stored inside collections. schemas of tables can be considered
// as documents in firestore. entire note schema is one document.
//===============================================================================
// ================= Streams of Data ============================================
// Firebase cloud storage gives us stream to work with.
// when you read notes from firestore they will be actually streams of data points.
// Update Auth user to contain ID, so we can associate notes with user Id.
// as we are dealing with email and password authentication in this app and not
// with other types of authentications, so email can't be optional it is always
// there.
//==================================================================================
// creating a cloud note there should be primary key associated with that note.
// every doc stored inside firestore has to have a primary key.
//=================================================================================
// when you are creating an instance variable in a class, and you declare it as
// final, then you need to initialize it in constructor, cannot be initialized
// inside setter or any function
//--------------------------------------------------------------------------
/*
--> NoSql means it is document based, means there is no real structure of
what you are adding to the database. it is document to which you are adding
fields.
 --> Where clause can be used for searching in a collection based on some condition.
--> USING then() inside future allow you to return a synchronous value from that
future or let you return another future from that.
----------> APPROACH OF REFRACTING CODE IS CUT THAT CODE FROM SOURCE.<----------

 */