class UserModel {
  final String id;
  final String username;
  final String email;
  final bool isAdmin;
  final String yearOfStudy;
  final String branch;
  final List<String> skills;
  final String avatar;
  final String description;
  final String resume;
  final String accessToken;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.accessToken,
    required this.id,
    required this.username,
    required this.email,
    required this.isAdmin,
    required this.yearOfStudy,
    required this.branch,
    required this.skills,
    required this.avatar,
    required this.description,
    required this.resume,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['accessToken'] ?? '',
      id: json['loggedUser']['_id'] ?? '',
      username: json['loggedUser']['username'] ?? '',
      email: json['loggedUser']['email'] ?? '',
      isAdmin: false,
      //todo: change this to json['loggedUser']['isAdmin'] ?? false,
      yearOfStudy: (json['loggedUser']['YearOFStudy'] ?? 0).toString(),
      branch: json['loggedUser']['Branch'] ?? '',
      skills: List<String>.from(json['loggedUser']['skills'] ?? []),
      avatar: json['loggedUser']['Avatar'] ?? '',
      description: json['loggedUser']['description'] ?? '',
      resume: json['loggedUser']['resume'] ?? '',
      createdAt: json['loggedUser']['createdAt'] ?? '',
      updatedAt: json['loggedUser']['updatedAt'] ?? '',
    );
  }
  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, isAdmin: $isAdmin, yearOfStudy: $yearOfStudy, branch: $branch, skills: ${skills.join(', ')}, avatar: $avatar, description: $description, resume: $resume, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
