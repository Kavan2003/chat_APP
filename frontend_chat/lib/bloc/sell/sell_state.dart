part of 'sell_bloc.dart';

@immutable
sealed class SellState {}

final class SellInitial extends SellState {}

final class SellLoading extends SellState {}

final class SellLoaded extends SellState {
  final AllSellModel sell;

  SellLoaded(this.sell);
}

final class SellError extends SellState {
  final String message;

  SellError(this.message);
}

final class SellIdLoaded extends SellState {
  final SellModel sell;

  SellIdLoaded(this.sell);
}

final class SellCreateSuccess extends SellState {
  final SellModel sell;

  SellCreateSuccess(this.sell);
}
