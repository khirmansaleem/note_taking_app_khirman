// 3 types of tests you can write in flutter:
// Unit Test
// Integration Test
// Widget Test
//-------------------------------------------------------------------------
// ===================================================================
// Unit Testing :::==>
//======================================================================
// writing tests for units of code typically functions or methods, to verify
// that they are behaving as expected in various conditions.
//-------------------------------------------------------------------
// unit can be single, functions or class.
//---------------------------------------------------------------------
//-------------------TDD (Test Driven Development)==>------------------
// writing the test before actually coding, during writing the test
// decide how the interface will look like for which you are writing
// test.
// AuthService is a unit of isolated code that communicate with auth
// provider and give
// us mirror of functionalities of the auth provider.
//====================================================================
// Widget Testing ==>
// In order to ensure that your widgets are working fine,
// For eg login button in UI, until the user logged in, this log in
// button should be disabled.
// end to end tests, widgets talking to services and services talk
//to provider and in turn provider talk to firebase and firebase talk
// to firebase backend.
// one end is UI button and other End is the service using which communicating
// so widget test is end to end.
//-----------------------------------------------------------------------
//=======================================================================
//A unit test tests a single function, method, or class.
//A widget te st (in other UI frameworks referred to as component test)
// tests a single widget.
// An integration test tests a complete app or a large part of an app.
//===================================================================
//in widget testing, whatever classes that are contributing
// to particular action of that widget will be involved in the test.
//------------------------------------------------------------------
// ========================================================================
// if you are testing AuthService.firebase(), issue commands like
// sign in user, create a user. So running tests and they will be end to
// end but UI is not involved.
//========================================================================
 // Mocking means imitating a real service.
// we will test auth service with a mock provider, or you can say a
// tester provider.
//========================================================================
// Dev Dependencies::==> dependencies that are only included in app while
// developing that app, once package that app those will not be included.
// they are not included in APK of the application.
//=======================================================================
// When you add a new dependency to app, you can't just do hot reload
// or hot restart, some of these dependencies require your app to be
// restarted or rebuild from scratch.
//=======================================================================
//-----------------------------------------------------------------------
// Dependency Injection <--:::-->==================================================================================>
// explaining it with example like authService is dependant on auth provider, it is not making an assumption that
// it is always including firebaseProvider only, auth service is dependant on a provider and using const constructor,
// injecting the provider into the AuthService.
//================================================================================================================>
//+++++++++++++++++++++++++++++++++++++++++++++++ MOCK AUTH PROVIDER++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// creating a provider which includes all the functionalities that auth provider has but some customize logic will
// be there.
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Test Groups---> For grouping together similar tests. every test group has a name.
//----------------------------------------------------------------------------------------------------------
// ========================= Asynchronous timeout testing====================================================
// how you can test timeout and api calls, asynchronous testing with timeout that says test should fail
// if initialize on provider takes more than x seconds.
