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
    if (json['Owner'] == null) {
      return UserModel(
        accessToken: json['accessToken'] ?? '',
        id: json['_id'] ?? '',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        isAdmin: false,
        //todo: change this to json['loggedUser']['isAdmin'] ?? false,
        yearOfStudy: (json['YearOFStudy'] ?? 0).toString(),
        branch: json['Branch'] ?? '',
        skills: List<String>.from(json['skills'] ?? []),
        avatar: json['Avatar'] ?? '',
        description: json['description'] ?? '',
        resume: json['resume'] ?? '',
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );
    }
    return UserModel(
      accessToken: json['accessToken'] ?? '',
      id: json['Owner']['_id'] ?? '',
      username: json['Owner']['username'] ?? '',
      email: json['Owner']['email'] ?? '',
      isAdmin: false,
      //todo: change this to json['loggedUser']['isAdmin'] ?? false,
      yearOfStudy: (json['Owner']['YearOFStudy'] ?? 0).toString(),
      branch: json['Owner']['Branch'] ?? '',
      skills: List<String>.from(json['Owner']['skills'] ?? []),
      avatar: json['Owner']['Avatar'] ?? '',
      description: json['Owner']['description'] ?? '',
      resume: json['Owner']['resume'] ?? '',
      createdAt: json['Owner']['createdAt'] ?? '',
      updatedAt: json['Owner']['updatedAt'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      '_id': id,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'YearOFStudy': yearOfStudy,
      'Branch': branch,
      'skills': skills,
      'Avatar': avatar,
      'description': description,
      'resume': resume,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, isAdmin: $isAdmin, yearOfStudy: $yearOfStudy, branch: $branch, skills: ${skills.join(', ')}, avatar: $avatar, description: $description, resume: $resume, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
