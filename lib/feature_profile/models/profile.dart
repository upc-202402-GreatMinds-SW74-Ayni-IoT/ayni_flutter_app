class Profile {
  final int id;
  final String username;
  final String email;


  const Profile({
    required this.id,
    required this.username,
    required this.email,
  });

  Profile.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        email = json["email"];

}
