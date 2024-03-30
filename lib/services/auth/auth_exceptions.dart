// Login exceptions:::
class InvalidCredentialsAuthException implements  Exception{}

// Register exceptions:
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// General exceptions:
class GenericAuthException implements Exception {}

// if the user is null after registering that user
class UserNotLoggedInAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}
