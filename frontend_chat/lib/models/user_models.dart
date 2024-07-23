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
  final String createdAt;
  final String updatedAt;

  UserModel({
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
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      yearOfStudy: json['YearOFStudy'] ?? 0,
      branch: json['Branch'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      avatar: json['Avatar'] ?? '',
      description: json['description'] ?? '',
      resume: json['resume'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, isAdmin: $isAdmin, yearOfStudy: $yearOfStudy, branch: $branch, skills: ${skills.join(', ')}, avatar: $avatar, description: $description, resume: $resume, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
