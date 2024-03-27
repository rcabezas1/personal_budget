class UserData {
  String uid;
  String email;
  String name;
  String picture;
  String theme;
  String? messageToken;

  UserData(this.uid, this.email, this.name, this.picture,
      {this.theme = "system"});

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        json['uid'] as String? ?? "",
        json['email'] as String? ?? "",
        json['name'] as String? ?? "",
        json['picture'] as String? ?? "",
        theme: json['theme'] as String? ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme': theme,
        'messageToken': messageToken,
      };
}
