import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistBloc({required this.getWatchlistMovies}) : super(WatchlistInitial()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(StateLoading());

      final result = await getWatchlistMovies.execute(event.kind);
      result.fold(
            (failure) {
          emit(ErrorMessage(failure.message));
        },
            (moviesData) {
          emit(WatchlistMovies(moviesData));
        },
      );
    });
  }
}
