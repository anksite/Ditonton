part of 'is_watchlist_bloc.dart';

abstract class IsWatchlistState extends Equatable {
  const IsWatchlistState();
}

class IsWatchlist extends IsWatchlistState {
  bool value;
  IsWatchlist(this.value);

  @override
  List<Object> get props => [value];
}

class WatchlistMessage extends IsWatchlistState {
  String value;
  WatchlistMessage(this.value);

  @override
  List<Object> get props => [value];
}
