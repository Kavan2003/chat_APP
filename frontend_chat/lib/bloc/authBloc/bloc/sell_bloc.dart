import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sell_event.dart';
part 'sell_state.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  SellBloc() : super(SellInitial()) {
    on<SellEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
