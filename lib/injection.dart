import 'package:ditonton/common/pinning_client.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/detail/bloc/detail_bloc.dart';
import 'package:ditonton/presentation/detail/bloc/is_watchlist_bloc.dart';
import 'package:ditonton/presentation/home/bloc/home_list_bloc.dart';
import 'package:ditonton/presentation/list_more/bloc/list_more_bloc.dart';
import 'package:ditonton/presentation/search/bloc/search_bloc.dart';
import 'package:ditonton/presentation/watchlist/bloc/watchlist_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'domain/usecases/get_tv_detail.dart';
import 'domain/usecases/get_tv_recommendations.dart';
import 'domain/usecases/search_tv.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => HomeListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
      getAiringTodayTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(
    () => ListMoreBloc(
      getPopularMovies: locator(),
      getNowPlayingMovies: locator(),
      getTopRatedMovies: locator(),
      getAiringTodayTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );
  locator.registerFactory(
    () => DetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getTvDetail: locator(),
      getTvRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => IsWatchlistBloc(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchBloc(
      searchMovies: locator(),
      searchTv: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistBloc(
      getWatchlistMovies: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetAiringTodayTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => PinningClient().client);
}
