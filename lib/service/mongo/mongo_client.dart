import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:personal_budget/storage/memory_storage.dart';

class MongoClient extends http.BaseClient {
  final bool defaultApiKey;
  String apiKey = dotenv.get("MONGO_API_KEY");

  MongoClient({this.defaultApiKey = false}) {
    if (!defaultApiKey) {
      apiKey = MemoryStorage.instance.userData?.apiKey ??
          dotenv.get("MONGO_API_KEY");
    }
  }

  get mongoService {
    var dataApi = dotenv.get("MONGO_SERVICE");
    if (!defaultApiKey) {
      dataApi = MemoryStorage.instance.userData?.dataApi ??
          dotenv.get("MONGO_SERVICE");
    }
    return "$dataApi/action";
  }

  get dataBase {
    var dataBase = dotenv.get("DATABASE");
    if (!defaultApiKey) {
      dataBase =
          MemoryStorage.instance.userData?.dataBase ?? dotenv.get("DATABASE");
    }
    return dataBase;
  }

  get dataSource {
    var dataSource = dotenv.get("DATASOURCE");
    if (!defaultApiKey) {
      dataSource = MemoryStorage.instance.userData?.dataSource ??
          dotenv.get("DATASOURCE");
    }
    return dataSource;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['api-key'] = apiKey;
    request.headers['content-type'] = 'application/json';
    request.headers['Access-Control-Request-Header'] = "*";
    request.headers['Access-Control-Allow-Origin'] = "*";
    return http.Client().send(request);
  }
}
