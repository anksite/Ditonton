import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_popular_tv.dart';
import '../../domain/usecases/get_top_rated_tv.dart';

class ListMoreNotifier extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetAiringTodayTv getAiringTodayTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  ListMoreNotifier(
      {required this.getNowPlayingMovies,
      required this.getPopularMovies,
      required this.getTopRatedMovies,
      required this.getAiringTodayTv,
      required this.getPopularTv,
      required this.getTopRatedTv});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  String _message = '';

  String get message => _message;

  Future<void> fetchMovies(String showedList) async {
    _state = RequestState.Loading;
    notifyListeners();

    Either<Failure, List<Movie>> result;
    if (showedList == MOVIE_NOW_PLAYING) {
      result = await getNowPlayingMovies.execute();
    } else if (showedList == MOVIE_POPULAR) {
      result = await getPopularMovies.execute();
    } else if (showedList == MOVIE_TOP_RATED) {
      result = await getTopRatedMovies.execute();
    } else if (showedList == TV_AIRING_TODAY) {
      result = await getAiringTodayTv.execute();
    } else if (showedList == TV_POPULAR) {
      result = await getPopularTv.execute();
    } else {
      //if(showedList==TV_TOP_RATED)
      result = await getTopRatedTv.execute();
    }

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _movies = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
