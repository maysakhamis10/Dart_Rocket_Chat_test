class NetworkException implements Exception{

  final String msg;
  const NetworkException(this.msg);
  String toString() => '$msg';

}