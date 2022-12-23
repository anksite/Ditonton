import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/home/bloc/home_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../bloc/home_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetAiringTodayTv,
  GetPopularTv,
  GetTopRatedTv
])
void main() {
  late HomeListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();

    mockGetAiringTodayTv = MockGetAiringTodayTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();

    bloc = HomeListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
      getAiringTodayTv: mockGetAiringTodayTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    );
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

  group('now playing movies', () {
    test('initialState should be MovieListInitial', () {
      expect(bloc.state, MovieListInitial());
    });

    blocTest<HomeListBloc, HomeListState>(
      'Should emit PageTitle("Movies") when SetPageTitle("Movies") event is added ',
      build: () {
        return bloc;
      },
      act: (b) => b.add(SetPageTitle("Movies")),
      expect: () => [
        PageTitle("Movies"),
      ],
    );

    blocTest<HomeListBloc, HomeListState>(
      'Should emit NowState(RequestState.Loading) and NowListData when FetchNowPlayingMovies event is added',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchNowPlayingMovies()),
      expect: () => [
        NowState(RequestState.Loading),
        NowListData(tMovieList)
      ],
      verify: (b) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchNowPlayingMovies()),
      expect: () => [
        NowState(RequestState.Loading),
        NowState(RequestState.Error),
      ],
    );
  });

  group('popular movies', () {
    blocTest<HomeListBloc, HomeListState>(
      'Should emit PopularState(RequestState.Loading) and PopularListData when FetchPopularMovies event is added',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchPopularMovies()),
      expect: () => [
        PopularState(RequestState.Loading),
        PopularListData(tMovieList)
      ],
      verify: (b) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularMovies()),
      expect: () => [
        PopularState(RequestState.Loading),
        PopularState(RequestState.Error),
      ],
    );
  });

  group('top rated movies', () {
    blocTest<HomeListBloc, HomeListState>(
      'Should emit TopRatedState(RequestState.Loading) and TopRatedListData when FetchTopRatedMovies event is added',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedState(RequestState.Loading),
        TopRatedListData(tMovieList)
      ],
      verify: (b) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedState(RequestState.Loading),
        TopRatedState(RequestState.Error),
      ],
    );
  });

  group('airing today tv', () {

    blocTest<HomeListBloc, HomeListState>(
      'Should emit PageTitle("TV Show") when SetPageTitle("TV Show") event is added ',
      build: () {
        return bloc;
      },
      act: (b) => b.add(SetPageTitle("TV Show")),
      expect: () => [
        PageTitle("TV Show"),
      ],
    );

    blocTest<HomeListBloc, HomeListState>(
      'Should emit NowState(RequestState.Loading) and NowListData when FetchAiringTodayTv event is added',
      build: () {
        when(mockGetAiringTodayTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchAiringTodayTv()),
      expect: () => [
        NowState(RequestState.Loading),
        NowListData(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetAiringTodayTv.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetAiringTodayTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchAiringTodayTv()),
      expect: () => [
        NowState(RequestState.Loading),
        NowState(RequestState.Error),
      ],
    );
  });

  group('popular tv', () {
    blocTest<HomeListBloc, HomeListState>(
      'Should emit PopularState(RequestState.Loading) and PopularListData when FetchPopularTv event is added',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTv()),
      expect: () => [
        PopularState(RequestState.Loading),
        PopularListData(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetPopularTv.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchPopularTv()),
      expect: () => [
        PopularState(RequestState.Loading),
        PopularState(RequestState.Error),
      ],
    );
  });

  group('top rated tv', () {
    blocTest<HomeListBloc, HomeListState>(
      'Should emit TopRatedState(RequestState.Loading) and TopRatedListData when FetchTopRatedTv event is added',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedState(RequestState.Loading),
        TopRatedListData(tMovieListTv)
      ],
      verify: (b) {
        verify(mockGetTopRatedTv.execute());
      },
    );

    blocTest<HomeListBloc, HomeListState>(
      'should return RequestState.Loading then RequestState.Error when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedState(RequestState.Loading),
        TopRatedState(RequestState.Error),
      ],
    );
  });

}
