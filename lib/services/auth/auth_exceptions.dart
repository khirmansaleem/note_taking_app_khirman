// Login exceptions:::
class InvalidCredentialsAuthException {}

// Register exceptions:
class WeakPasswordAuthException {}

class EmailAlreadyInUseAuthException {}

class InvalidEmailAuthException {}

// General exceptions:
class GenericAuthException {}

// if the user is null after registering that user
class UserNotLoggedInAuthException {}
