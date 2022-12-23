part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();
}

class WatchlistInitial extends WatchlistState {
  @override
  List<Object> get props => [];
}

class StateLoading extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistMovies extends WatchlistState {
  List<Movie> value;
  WatchlistMovies(this.value);

  @override
  List<Object?> get props => [value];
}

class ErrorMessage extends WatchlistState {
  String value;
  ErrorMessage(this.value);

  @override
  List<Object?> get props => [value];
}
