// class SearchHistoryModel {
//   // final bool status;
//   // final String message;
//   final SearchHistoryData data;

//   SearchHistoryModel({
//     // required this.status,
//     // required this.message,
//     required this.data,
//   });

//   factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
//     return SearchHistoryModel(
//       // status: json['status'],
//       // message: json['message'],
//       data: SearchHistoryData.fromJson(json['data']),
//     );
//   }
// }

class SearchHistoryData {
  final List<TrendingTerm> trending;
  final List<RecentSearch> recents;

  SearchHistoryData({
    required this.trending,
    required this.recents,
  });

  factory SearchHistoryData.fromJson(Map<String, dynamic> json) {
    return SearchHistoryData(
      trending: List<TrendingTerm>.from(
        json['trending'].map((term) => TrendingTerm.fromJson(term)),
      ),
      recents: List<RecentSearch>.from(
        json['recents'].map((search) => RecentSearch.fromJson(search)),
      ),
    );
  }
}

class TrendingTerm {
  final String term;
  final int count;

  TrendingTerm({
    required this.term,
    required this.count,
  });

  factory TrendingTerm.fromJson(Map<String, dynamic> json) {
    return TrendingTerm(
      term: json['term'],
      count: json['count'],
    );
  }
}

class RecentSearch {
  final String id;
  final String search;
  final String createdAt;

  RecentSearch({
    required this.id,
    required this.search,
    required this.createdAt,
  });

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(
      id: json['_id'],
      search: json['search'],
      createdAt: json['createdAt'],
    );
  }
}
