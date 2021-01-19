class UserModel {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        photoUrl = json['photoUrl'],
        displayName = json['displayName'],
        uid = json['uid'];
}
