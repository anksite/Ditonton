part of 'watchlist_bloc.dart';

abstract class WatchlistEvent {
  const WatchlistEvent();
}

class FetchWatchlistMovies extends WatchlistEvent {
  String kind;
  FetchWatchlistMovies(this.kind);
}
