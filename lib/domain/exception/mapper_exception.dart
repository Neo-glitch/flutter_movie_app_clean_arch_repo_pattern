// ignore_for_file: public_member_api_docs, sort_constructors_first

///To handle exception thrown when mapping from [From] to [To] class
///
class MapperException<From, To> implements Exception {
  final String message;
  MapperException(this.message);

  @override
  String toString() => "Error when mapping class $From TO $To : $message";
}
