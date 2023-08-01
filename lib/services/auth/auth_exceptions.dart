// Login exceptions

class UserNotFoundAuthExc implements Exception {}

class WrongPassAuthExc implements Exception {}

class NullPasswordExc implements Exception {}

// Register exceptions

class WeakPassAuthExc implements Exception {}

class EmailUsedAuthExc implements Exception {}

class InvalidEmailAuthExc implements Exception {}

// Pass reset exception

class ErrorSendingResetEmailExc implements Exception {}

// Generic exceptions

class GenericAuthExc implements Exception {}

class UserNotLoggedExc implements Exception {}
