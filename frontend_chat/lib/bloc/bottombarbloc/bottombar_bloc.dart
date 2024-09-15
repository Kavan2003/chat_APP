import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottombar_event.dart';
part 'bottombar_state.dart';

class BottombarBloc extends Bloc<BottombarEvent, BottombarState> {
  BottombarBloc() : super(BottombarInitial()) {
    on<BottombarEvent>((event, emit) {
      on<BottombarckickedEvent>((event, emit) {
        emit(BottombarChanged(index: event.index));
      });
    });
  }
}
