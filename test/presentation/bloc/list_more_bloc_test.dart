import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/list_more/bloc/list_more_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../bloc/list_more_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetAiringTodayTv,
  GetPopularTv,
  GetTopRatedTv,
])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late ListMoreBloc bloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();

    bloc = ListMoreBloc(
        getNowPlayingMovies: mockGetNowPlayingMovies,
        getPopularMovies: mockGetPopularMovies,
        getTopRatedMovies: mockGetTopRatedMovies,
        getAiringTodayTv: mockGetAiringTodayTv,
        getPopularTv: mockGetPopularTv,
        getTopRatedTv: mockGetTopRatedTv);

  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    name: null,
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  final tMovieTv = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: null,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: null,
    title: null,
    name: 'name',
    video: null,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieListTv = <Movie>[tMovieTv];

  group("Now Playing Movie", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieList) when FetchMovies(MOVIE_NOW_PLAYING) event is added',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_NOW_PLAYING)),
      expect: () => [
        StateLoading(),
        Movies(tMovieList)
      ],
      verify: (b) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_NOW_PLAYING)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group("Popular Movie", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieList) when FetchMovies(MOVIE_POPULAR) event is added',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_POPULAR)),
      expect: () => [
        StateLoading(),
        Movies(tMovieList)
      ],
      verify: (b) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_POPULAR)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group("Top Rated Movie", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieList) when FetchMovies(MOVIE_TOP_RATED) event is added',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_TOP_RATED)),
      expect: () => [
        StateLoading(),
        Movies(tMovieList)
      ],
      verify: (b) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(MOVIE_TOP_RATED)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group("Airing Today Tv", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieListTv) when FetchMovies(TV_AIRING_TODAY) event is added',
      build: () {
        when(mockGetAiringTodayTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_AIRING_TODAY)),
      expect: () => [
        StateLoading(),
        Movies(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetAiringTodayTv.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetAiringTodayTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_AIRING_TODAY)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group("Popular Tv", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieListTv) when FetchMovies(TV_POPULAR) event is added',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_POPULAR)),
      expect: () => [
        StateLoading(),
        Movies(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_POPULAR)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group("Top Rated Tv", (){
    blocTest<ListMoreBloc, ListMoreState>(
      'Should emit StateLoading() and Movies(tMovieListTv) when FetchMovies(TV_TOP_RATED) event is added',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_TOP_RATED)),
      expect: () => [
        StateLoading(),
        Movies(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<ListMoreBloc, ListMoreState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovies(TV_TOP_RATED)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

}
