import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/detail/bloc/detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late DetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    bloc = DetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  final tId = 1;

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
  final tMovies = <Movie>[tMovie];

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
  final tMoviesTv = <Movie>[tMovieTv];

  void _arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  void _arrangeUsecaseTv() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMoviesTv));
  }

  group('Get Movie Detail and Recommendation', () {
    blocTest<DetailBloc, DetailState>(
      'Should emit MovieLoading(), RecommendationLoading() and MovieData, MovieRecommendations when FetchMovieDetail event is added',
      build: () {
        _arrangeUsecase();
       return bloc;
      },
      act: (b) => b.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieLoading(),
        RecommendationLoading(),
        MovieData(testMovieDetail),
        MovieRecommendations(tMovies),
      ],
      verify: (b) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<DetailBloc, DetailState>(
      'should return MovieLoading() then ErrorDetail when data is unsuccessful',
      build: () {
        _arrangeUsecase();
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieLoading(),
        ErrorDetail('Server Failure')
      ],
    );
  });

  group('Get TV Detail and Recommendation', () {
    blocTest<DetailBloc, DetailState>(
      'Should emit MovieLoading(), RecommendationLoading() and MovieData, MovieRecommendations when FetchMovieDetail event is added',
      build: () {
        _arrangeUsecaseTv();
        return bloc;
      },
      act: (b) => b.add(FetchTvDetail(tId)),
      expect: () => [
        MovieLoading(),
        RecommendationLoading(),
        MovieData(testTvDetail),
        MovieRecommendations(tMoviesTv),
      ],
      verify: (b) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<DetailBloc, DetailState>(
      'should return MovieLoading() then ErrorDetail when data is unsuccessful',
      build: () {
        _arrangeUsecaseTv();
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchTvDetail(tId)),
      expect: () => [
        MovieLoading(),
        ErrorDetail('Server Failure')
      ],
    );
  });

}
