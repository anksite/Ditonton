import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../common/constants.dart';
import '../../../common/failure.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_airing_today_tv.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_popular_tv.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';
import '../../../domain/usecases/get_top_rated_tv.dart';

part 'list_more_event.dart';
part 'list_more_state.dart';

class ListMoreBloc extends Bloc<ListMoreEvent, ListMoreState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  final GetAiringTodayTv getAiringTodayTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  ListMoreBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getAiringTodayTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(ListMoreInitial()) {

    on<FetchMovies>((event, emit) async {
      emit(StateLoading());

      Either<Failure, List<Movie>> result;
      if (event.showedList == MOVIE_NOW_PLAYING) {
        result = await getNowPlayingMovies.execute();
      } else if (event.showedList == MOVIE_POPULAR) {
        result = await getPopularMovies.execute();
      } else if (event.showedList == MOVIE_TOP_RATED) {
        result = await getTopRatedMovies.execute();
      } else if (event.showedList == TV_AIRING_TODAY) {
        result = await getAiringTodayTv.execute();
      } else if (event.showedList == TV_POPULAR) {
        result = await getPopularTv.execute();
      } else {
        //if(event.showedList==TV_TOP_RATED)
        result = await getTopRatedTv.execute();
      }

      result.fold(
            (failure) {
          emit(ErrorMessage(failure.message));
        },
            (moviesData) {
          emit(Movies(moviesData));
        },
      );
    });

  }
}
