import 'package:personal_budget/service/mongo/mongo_client.dart';

import '../filters/filter_valid.dart';
import '../filters/mongo_filter.dart';

enum MongoOperationType { upsert, delete, updateAll, find }

class MongoRequest {
  MongoClient client;
  String collection;
  dynamic document;
  MongoFilter? filter;
  String id = "";
  MongoOperationType type = MongoOperationType.find;

  MongoRequest.filter(this.client, this.collection, {this.filter});
  MongoRequest.upsert(
      this.client, this.collection, this.filter, this.document) {
    type = MongoOperationType.upsert;
  }
  MongoRequest.delete(this.client, this.collection, this.filter) {
    type = MongoOperationType.delete;
  }
  MongoRequest.updateAll(
      this.client, this.collection, this.filter, this.document) {
    type = MongoOperationType.updateAll;
  }

  Map<String, dynamic> toJson() {
    switch (type) {
      case MongoOperationType.upsert:
        return <String, dynamic>{
          'collection': collection,
          'dataSource': client.dataSource,
          'database': client.dataBase,
          'filter': filter,
          'update': MongoUpdateRequest(document),
          "upsert": true,
        };
      case MongoOperationType.delete:
        return <String, dynamic>{
          'collection': collection,
          'dataSource': client.dataSource,
          'database': client.dataBase,
          'filter': filter,
        };
      case MongoOperationType.updateAll:
        return <String, dynamic>{
          'collection': collection,
          'dataSource': client.dataSource,
          'database': client.dataBase,
          'filter': filter,
          'update': MongoUpdateRequest(document),
        };
      default:
        return <String, dynamic>{
          'collection': collection,
          'dataSource': client.dataSource,
          'database': client.dataBase,
          'filter': filter ?? FilterValid(true)
        };
    }
  }
}

class MongoUpdateRequest {
  dynamic document;
  MongoUpdateRequest(this.document);
  Map<String, dynamic> toJson() => <String, dynamic>{"\$set": document};
}

class Projection {
  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': 1,
        'id': 1,
        'commerce': 1,
        'value': 1,
        'type': 1,
        'sms': 1,
        'category': 1,
        'description': 1,
        'date': 1,
        'valid': 1
      };
}
