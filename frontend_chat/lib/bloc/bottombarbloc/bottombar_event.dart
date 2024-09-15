part of 'bottombar_bloc.dart';

@immutable
sealed class BottombarEvent {}

class BottombarckickedEvent extends BottombarEvent {
  final int index;

  BottombarckickedEvent({required this.index});
}
