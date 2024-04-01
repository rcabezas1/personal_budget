class UserData {
  String uid;
  String email;
  String name;
  String picture;
  String? theme;
  String fuid;

  UserData(this.uid, this.email, this.name, this.picture, this.fuid,
      {this.theme = "system"});

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        json['uid'] as String? ?? "",
        json['email'] as String? ?? "",
        json['name'] as String? ?? "",
        json['picture'] as String? ?? "",
        json['fuid'] as String? ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'email': email,
        'name': name,
        'picture': picture,
        'fuid': fuid,
      };
}
