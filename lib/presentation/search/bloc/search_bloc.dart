import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/search_movies.dart';
import '../../../domain/usecases/search_tv.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final SearchTv searchTv;

  SearchBloc({required this.searchMovies, required this.searchTv}) : super(SearchInitial()) {
    on<FetchMovieSearch>((event, emit) async {
      emit(StateLoading());

      final result = await searchMovies.execute(event.query);
      result.fold(
            (failure) {
              emit(ErrorMessage(failure.message));
        },
            (data) {
              emit(SearchResult(data));
        },
      );
    });

    on<FetchTvSearch>((event, emit) async {
      emit(StateLoading());

      final result = await searchTv.execute(event.query);
      result.fold(
            (failure) {
          emit(ErrorMessage(failure.message));
        },
            (data) {
          emit(SearchResult(data));
        },
      );
    });
  }
}
