const database = "budget";
const dataSource = "Cluster0";

class MongoRequest {
  String collection;
  dynamic document;
  String? filter;
  String id = "";
  bool upsert = false;
  bool delete = false;

  MongoRequest.filter(this.collection, {this.filter});
  MongoRequest.upsert(this.collection, this.id, this.document) {
    upsert = true;
  }

  MongoRequest.delete(this.collection, this.id) {
    delete = true;
  }

  Map<String, dynamic> toJson() {
    if (upsert) {
      return <String, dynamic>{
        'collection': collection,
        'dataSource': dataSource,
        'database': database,
        'filter': FilterBudgetId(id),
        'update': MongoUpdateRequest(document),
        "upsert": upsert
      };
    } else if (delete) {
      return <String, dynamic>{
        'collection': collection,
        'dataSource': dataSource,
        'database': database,
        'filter': FilterBudgetId(id),
      };
    } else {
      return <String, dynamic>{
        'collection': collection,
        'dataSource': dataSource,
        'database': database,
        'filter': MongoFilter(true)
      };
    }
  }
}

class MongoFilter {
  bool valid;
  MongoFilter(this.valid);
  Map<String, dynamic> toJson() => <String, dynamic>{"valid": valid};
}

class MongoUpdateRequest {
  dynamic document;
  MongoUpdateRequest(this.document);
  Map<String, dynamic> toJson() => <String, dynamic>{"\$set": document};
}

class FilterBudgetId {
  String id;
  FilterBudgetId(this.id);
  Map<String, dynamic> toJson() => <String, dynamic>{"id": id};
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
