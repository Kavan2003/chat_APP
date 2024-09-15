import 'user_models.dart'; // Import the UserModel

class JobModel {
  final String id;
  final UserModel owner;
  final List<String> skills;
  final String jobDescription;
  final String companyWebsite;
  final String createdAt;
  final String updatedAt;

  JobModel({
    required this.id,
    required this.owner,
    required this.skills,
    required this.jobDescription,
    required this.companyWebsite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      owner: UserModel.fromJson(json),
      skills: List<String>.from(json['skills'] ?? []),
      jobDescription: json['jobDescription'] ?? '',
      companyWebsite: json['companyWebsite'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Owner': owner.toJson(),
      'skills': skills,
      'jobDescription': jobDescription,
      'companyWebsite': companyWebsite,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'JobModel(id: $id, owner: $owner, skills: ${skills.join(', ')}, jobDescription: $jobDescription, companyWebsite: $companyWebsite, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class AllJobModel {
  final List<JobModel> data;

  AllJobModel({
    required this.data,
  });

  factory AllJobModel.fromJson(List<dynamic> list) {
    return AllJobModel(
      data: list.map((job) => JobModel.fromJson(job)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((job) => job.toJson()).toList(),
    };
  }
}
