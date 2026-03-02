class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class FirestoreException extends AppException {
  FirestoreException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class StorageException extends AppException {
  StorageException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
  });
}
