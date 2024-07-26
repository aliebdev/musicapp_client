class AppFailure {
  final String message;
  final int? statusCode;

  AppFailure([
    this.message = 'An unexpected error occurd!',
    this.statusCode,
  ]);
}
