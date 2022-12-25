import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_airing_today_tv.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_popular_tv.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';
import '../../../domain/usecases/get_top_rated_tv.dart';

part 'home_list_event.dart';

part 'home_list_state.dart';

class HomeListBloc extends Bloc<HomeListEvent, HomeListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  final GetAiringTodayTv getAiringTodayTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  HomeListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getAiringTodayTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(MovieListInitial()) {
    on<SetPageTitle>((event, emit) {
      emit(PageTitle(event.pageTitle));
    });

    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowState(RequestState.Loading));
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(NowState(RequestState.Error));
        },
        (moviesData) {
          emit(NowListData(moviesData));
        },
      );
    });

    on<FetchPopularMovies>((event, emit) async {
      emit(PopularState(RequestState.Loading));
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(PopularState(RequestState.Error));
        },
        (moviesData) {
          emit(PopularListData(moviesData));
        },
      );
    });

    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedState(RequestState.Loading));
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(TopRatedState(RequestState.Error));
        },
        (moviesData) {
          emit(TopRatedListData(moviesData));
        },
      );
    });

    on<FetchAiringTodayTv>((event, emit) async {
      emit(NowState(RequestState.Loading));
      final result = await getAiringTodayTv.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(NowState(RequestState.Error));
        },
        (moviesData) {
          emit(NowListData(moviesData));
        },
      );
    });

    on<FetchPopularTv>((event, emit) async {
      emit(PopularState(RequestState.Loading));
      final result = await getPopularTv.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(PopularState(RequestState.Error));
        },
        (moviesData) {
          emit(PopularListData(moviesData));
        },
      );
    });

    on<FetchTopRatedTv>((event, emit) async {
      emit(TopRatedState(RequestState.Loading));
      final result = await getTopRatedTv.execute();
      result.fold(
        (failure) {
          print(failure.message);
          emit(TopRatedState(RequestState.Error));
        },
        (moviesData) {
          emit(TopRatedListData(moviesData));
        },
      );
    });
  }
}
