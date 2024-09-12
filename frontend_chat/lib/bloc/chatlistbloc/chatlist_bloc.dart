import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
part 'chatlist_event.dart';
part 'chatlist_state.dart';

class ChatlistBloc extends Bloc<ChatlistEvent, ChatlistState> {
  ChatlistBloc() : super(ChatlistInitial()) {
    on<FetchChatList>((event, emit) async {
//http://localhost:8000/api/chat/listchats
      emit(ChatlistLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';

        final url = Uri.parse('${apiroute}chat/listchats');

        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $accesstoken',
          },
        );
        print(response.body);

        final chatListResponse = ApiResponse<ChatListResponse>.fromJson(
            response.body, (json) => ChatListResponse.fromJson(json));
        chatListResponse.status == "true"
            ? emit(ChatlistLoaded(chatListResponse.data!))
            : emit(ChatlistError(chatListResponse.message));
      } catch (error) {
        print('Api Fetch Error on chatlist ${error}');
        emit(ChatlistError('Api Fetch Error on chatlist${error.toString()}'));
      }
    });
    // TODO: on<RefreshChatList>((event, emit) {});
  }
}
