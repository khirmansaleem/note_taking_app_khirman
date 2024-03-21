const dbname='notes.db';
const notesTable='note';
const userTable='user';
const columnId = 'id';
const columnEmail = 'email';
const columnUserid='user_id';
const columnText='text';
const columnSynced='is_synced_with_cloud';


const createNotesTable= '''
      CREATE TABLE IF NOT EXISTS "note" (
	     "id"	INTEGER NOT NULL,
	     "user_id"	INTEGER NOT NULL,
	     "text"	TEXT NOT NULL,
	     "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	     PRIMARY KEY("id" AUTOINCREMENT),
	     FOREIGN KEY("user_id") REFERENCES "user"("id")
       );
       ''';

const createUserTable = '''
      CREATE TABLE IF NOT EXISTS "user" (
	    "id"	INTEGER NOT NULL,
	    "email"	TEXT NOT NULL UNIQUE,
	     PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';