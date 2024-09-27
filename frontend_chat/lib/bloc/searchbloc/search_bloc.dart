import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/search_histort_model.dart';
import 'package:frontend_chat/models/search_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchUser>((event, emit) async {
      emit(SearchLoading());
      try {
        final url =
            Uri.parse('$apiroute$chatRoute/search?query=${event.query}');
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';

// http://localhost:8000/api/chat/search?query=Industry
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $accesstoken',
            'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
          },
        );
        print(response.body);
        final searchResponse = ApiResponse<SearchResponse>.fromJson(
            response.body, (json) => SearchResponse.fromJson(json));
        searchResponse.status == "true"
            ? emit(SearchResults(searchResponse.data!))
            : emit(SearchError(searchResponse.message));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
    on<SearchEmpty>((event, emit) async {
//triggered when search query is empty

      emit(SearchLoading());
      try {
        final url = Uri.parse('$apiroute$chatRoute/searchhistory');
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';

// http://localhost:8000/api/chat/search?query=Industry
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $accesstoken',
            'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
          },
        );
        print(response.body);
        final searchhistoryResponse = ApiResponse<SearchHistoryData>.fromJson(
            response.body, (json) => SearchHistoryData.fromJson(json));
        searchhistoryResponse.status == "true"
            ? emit(SearchhHistoryResults(searchhistoryResponse.data!))
            : emit(SearchError(searchhistoryResponse.message));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}
