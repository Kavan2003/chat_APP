part of 'sell_bloc.dart';

@immutable
sealed class SellEvent {}

class SellSearchEvent extends SellEvent {
  final String query;

  SellSearchEvent(this.query);
}

class SellviewIdEvent extends SellEvent {
  final String id;

  SellviewIdEvent(this.id);
}

class SellCreateEvent extends SellEvent {
  final String name;
  final String description;
  final String price;
  final List<String> images;

  SellCreateEvent(this.name, this.description, this.price, this.images);
}
