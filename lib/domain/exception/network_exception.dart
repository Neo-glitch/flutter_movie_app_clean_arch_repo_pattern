// ignore_for_file: public_member_api_docs, sort_constructors_first
/// handles api request exception
class NetworkException implements Exception {
  final int statusCode;
  String? message;
  NetworkException({
    required this.statusCode,
    this.message,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "Netowork Exception: status code $statusCode, message: $message";
  }
}
