class SmsParts {
  PartType type;
  String value;
  SmsParts(this.type, this.value);
}

enum PartType { commerce, value, date, undefined }
