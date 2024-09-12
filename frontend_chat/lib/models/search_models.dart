class SearchModel {
  String id;
  String username;
  String branch;
  List<String> skills;
  String description;

  SearchModel({
    required this.id,
    required this.username,
    required this.branch,
    required this.skills,
    required this.description,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['_id'],
      username: json['username'],
      branch: json['Branch'],
      skills: List<String>.from(json['skills']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'Branch': branch,
      'skills': skills,
      'description': description,
    };
  }
}

class SearchResponse {
  final List<SearchModel> data;

  SearchResponse({
    required this.data,
  });

  factory SearchResponse.fromJson(List<dynamic> list) {
    return SearchResponse(
      data: list.map((user) => SearchModel.fromJson(user)).toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'data': data.map((user) => user.toJson()).toList(),
  //   };
  // }
}
