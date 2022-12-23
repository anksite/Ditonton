part of 'is_watchlist_bloc.dart';

abstract class IsWatchlistEvent {
  const IsWatchlistEvent();
}

class AddWatchlist extends IsWatchlistEvent {
  MovieDetail movie;
  AddWatchlist(this.movie);
}

class RemoveFromWatchlist extends IsWatchlistEvent {
  MovieDetail movie;
  RemoveFromWatchlist(this.movie);
}

class LoadWatchlistStatus extends IsWatchlistEvent {
  int id;
  LoadWatchlistStatus(this.id);
}
