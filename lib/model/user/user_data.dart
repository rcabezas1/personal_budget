class UserData {
  String uid;
  String email;
  String name;
  String picture;
  String? theme;
  String fuid;
  String apiKey;
  String dashboard;
  String dataApi;
  String dataBase;
  String dataSource;

  UserData(this.uid, this.email, this.name, this.picture, this.fuid,
      this.apiKey, this.dashboard, this.dataApi, this.dataBase, this.dataSource,
      {this.theme = "system"});

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        json['uid'] as String? ?? "",
        json['email'] as String? ?? "",
        json['name'] as String? ?? "",
        json['picture'] as String? ?? "",
        json['fuid'] as String? ?? "",
        json['apiKey'] as String? ?? "",
        json['dashboard'] as String? ?? "",
        json['dataApi'] as String? ?? "",
        json['dataBase'] as String? ?? "",
        json['dataSource'] as String? ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'email': email,
        'name': name,
        'picture': picture,
        'fuid': fuid,
        'apiKey': apiKey,
        'dashboard': dashboard,
        'dataApi': dataApi,
        'dataBase': dataBase,
        'dataSource': dataSource,
      };
}
