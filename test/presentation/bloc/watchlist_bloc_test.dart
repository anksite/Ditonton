import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/watchlist/bloc/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../bloc/watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

  group('watchlist movies', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'Should emit StateLoading() and WatchlistMovies([testWatchlistMovie]) when FetchWatchlistMovies event is added',
      build: () {
        when(mockGetWatchlistMovies.execute(MOVIE))
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies(MOVIE)),
      expect: () => [
        StateLoading(),
        WatchlistMovies([testWatchlistMovie])
      ],
      verify: (b) {
        verify(mockGetWatchlistMovies.execute(MOVIE));
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute(MOVIE))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies(MOVIE)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group('watchlist tv', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'Should emit StateLoading() and WatchlistMovies([testWatchlistTv]) when FetchWatchlistMovies event is added',
      build: () {
        when(mockGetWatchlistMovies.execute(TV))
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies(TV)),
      expect: () => [
        StateLoading(),
        WatchlistMovies([testWatchlistTv])
      ],
      verify: (b) {
        verify(mockGetWatchlistMovies.execute(TV));
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute(TV))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchWatchlistMovies(TV)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  // test('should change movies data when data is gotten successfully', () async {
  //   // arrange
  //   when(mockGetWatchlistMovies.execute(MOVIE))
  //       .thenAnswer((_) async => Right([testWatchlistMovie]));
  //   // act
  //   await provider.fetchWatchlistMovies(MOVIE);
  //   // assert
  //   expect(provider.watchlistState, RequestState.Loaded);
  //   expect(provider.watchlistMovies, [testWatchlistMovie]);
  //   expect(listenerCallCount, 2);
  // });
  //
  // test('should return error when data is unsuccessful', () async {
  //   // arrange
  //   when(mockGetWatchlistMovies.execute(MOVIE))
  //       .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
  //   // act
  //   await provider.fetchWatchlistMovies(MOVIE);
  //   // assert
  //   expect(provider.watchlistState, RequestState.Error);
  //   expect(provider.message, "Can't get data");
  //   expect(listenerCallCount, 2);
  // });
}
