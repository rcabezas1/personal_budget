import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MongoClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['api-key'] = dotenv.get("MONGO_API_KEY");
    request.headers['content-type'] = 'application/json';
    request.headers['Access-Control-Request-Header'] = "*";
    return http.Client().send(request);
  }
}
