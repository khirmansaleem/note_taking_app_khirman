/*
loading screen...................................................................
diff b/w helpers and utilities.
-->...........................................................................
Valid Email, User Exists: Firebase sends the password reset email.
Valid Email, No User: Firebase completes the request without sending an email
and without throwing an exception.
Invalid Email Format: Firebase throws an FirebaseAuthException with the
 code invalid-email.
 -------------------------------------------------------------------------
 --> Splash screen is the screen that flutter displays to it's users while
 loading the application. while loading the binary it can show splash screen
 to the user.
 ..........................................................................
Attribution -->
icon attribution to  stockio
https://www.stockio.com/free-icon/clipboard-subtle-color
// we need different icon sizes for different types of screens.
.............................................................................
AppIcon.co----> tool for outputting the app icons.
............................................................................
https://www.appicon.co/
// flutter launcher icons.--> dev
// delta format is used to represent rich text with various attributes like
bold, italic, underline and alignment.
--------------------------------------------------------------------------------
JSON is a format for representing structured data as text without formatting,
 while the Delta format is used to represent both the content and formatting of
 rich text documents.

--------------------------------------------------------------------------------
 What is a Delta?
 -------------------------------------------------------------------------------
 A delta is a collection of operations that describe changes
  to the document, including text insertions and formatting attributes.
   Each operation within a delta can specify not just the text to be inserted,
    but also formatting attributes like bold, italic, underline, font size,
    and more.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
How Does Formatting Work?
--------------------------------------------------------------------------------
 When you create a delta that includes formatting
information (for example, an insert operation with a bold attribute), the
QuillEditor interprets this delta and renders the text with the specified
 formatting applied. This is possible because the delta explicitly defines not
  just what text should appear, but how it should be styled.
================================================================================
--------------------------------------------------------------------------------
  delta can be use to render the formatted text inside the editor only.
  but if you want the formatted text to render outside the quill editor,
  you can use TextSpan for this purpose, it will replicate the formatting
  outside the editor.
 */