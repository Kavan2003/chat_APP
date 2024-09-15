part of 'bottombar_bloc.dart';

@immutable
sealed class BottombarState {}

final class BottombarInitial extends BottombarState {}

final class BottombarChanged extends BottombarState {
  final int index;

  BottombarChanged({required this.index});
}
