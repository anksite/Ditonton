import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/search/bloc/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../bloc/search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies, SearchTv])
void main() {
  late SearchBloc bloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTv = MockSearchTv();
    bloc = SearchBloc(
        searchMovies: mockSearchMovies, searchTv: mockSearchTv);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    name: null,
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  final tQuery = 'spiderman';

  final tMovieModelTv = Movie(
    adult: false,
    backdropPath: '/maFEWU41jdUOzDfRVkojq7fluIm.jpg',
    genreIds: [16, 35, 10751, 10765],
    id: 387,
    originalTitle: null,
    overview:
    "Deep down in the Pacific Ocean in the subterranean city of Bikini Bottom lives a square yellow sponge named SpongeBob SquarePants. SpongeBob lives in a pineapple with his pet snail, Gary, loves his job as a fry cook at the Krusty Krab, and has a knack for getting into all kinds of trouble without really trying. When he's not getting on the nerves of his cranky next door neighbor Squidward, SpongeBob can usually be found smack in the middle of all sorts of strange situations with his best buddy, the simple yet lovable starfish, Patrick, or his thrill-seeking surfer-girl squirrel pal, Sandy Cheeks.",
    popularity: 16.191,
    posterPath: '/amvtZgiTty0GHIgD56gpouBWrcy.jpg',
    releaseDate: null,
    title: null,
    name: "SpongeBob SquarePants",
    video: null,
    voteAverage: 7.585,
    voteCount: 2564,
  );
  final tMovieListTv = <Movie>[tMovieModelTv];
  final tQueryTv = 'spongebob';

  group('search movies', () {
    blocTest<SearchBloc, SearchState>(
      'Should emit StateLoading() and Movies(tMovieList) when FetchMovieSearch event is added',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (b) => b.add(FetchMovieSearch(tQuery)),
      expect: () => [
        StateLoading(),
        SearchResult(tMovieList)
      ],
      verify: (b) {
        verify(mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchMovieSearch(tQuery)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });

  group('search tv', () {
    blocTest<SearchBloc, SearchState>(
      'Should emit StateLoading() and Movies(tMovieListTv) when FetchTvSearch event is added',
      build: () {
        when(mockSearchTv.execute(tQueryTv))
            .thenAnswer((_) async => Right(tMovieListTv));
        return bloc;
      },
      act: (b) => b.add(FetchTvSearch(tQueryTv)),
      expect: () => [
        StateLoading(),
        SearchResult(tMovieListTv)
      ],
      verify: (b) {
        verify(mockSearchTv.execute(tQueryTv));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'should return StateLoading(), then ErrorMessager when data is unsuccessful',
      build: () {
        when(mockSearchTv.execute(tQueryTv))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (b) => b.add(FetchTvSearch(tQueryTv)),
      expect: () => [
        StateLoading(),
        ErrorMessage('Server Failure'),
      ],
    );
  });
}
