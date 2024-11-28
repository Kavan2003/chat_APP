class RequestStatusModel {
  final String status;
  final bool canAccept;

  RequestStatusModel({
    required this.status,
    required this.canAccept,
  });

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    return RequestStatusModel(
      status: json['status'] ?? '',
      canAccept: json['canAccept'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'canAccept': canAccept,
    };
  }

  @override
  String toString() {
    return 'RequestStatusModel(status: $status, canAccept: $canAccept)';
  }
}
