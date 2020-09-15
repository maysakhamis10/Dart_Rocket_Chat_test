import 'package:http/http.dart' as http;

class HttpService {
  String _apiUrl;


  HttpService(String apiUrl) {
    _apiUrl = apiUrl;
    print('APURL .. $apiUrl');
  }

  Future<http.Response> getWithMap(String uri, Map filter) async =>
      await http.get(_apiUrl + uri + '?' + _urlEncode(filter),
          headers: await _getHeaders());

  Future<http.Response> get(String uri) async =>
      await http.get(_apiUrl + uri, headers: await _getHeaders());

  Future<http.Response> post(String uri, String body) async =>
      await http.post(_apiUrl + uri, headers: await _getHeaders(), body: body);

  Future<http.Response> put(String uri, String body) async =>
      await http.put(_apiUrl + uri, headers: await _getHeaders(), body: body);

  Future<http.Response> delete(String uri) async =>
      await http.delete(_apiUrl + uri, headers: await _getHeaders());

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    return header;
  }
}

String _urlEncode(Map object) {
  int index = 0;
  String url = object.keys.map((key) {
    if (object[key]?.toString()?.isNotEmpty == true) {
      String value = "";
      if (index != 0) {
        value = "&";
      }
      index++;
      return "$value${Uri.encodeComponent(key)}=${Uri.encodeComponent(object[key].toString())}";
    }
    return "";
  }).join();
  return url;
}
