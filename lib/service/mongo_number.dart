class MongoNumberLong {
  int value;
  MongoNumberLong(this.value);
  Map<String, dynamic> toJson() => <String, dynamic>{"\$numberLong": "$value"};
}

class MongoNumberDouble {
  double value;
  MongoNumberDouble(this.value);
  Map<String, dynamic> toJson() =>
      <String, dynamic>{"\$numberDouble": "$value"};
}
