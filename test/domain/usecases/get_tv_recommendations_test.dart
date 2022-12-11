import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tMovies = <Movie>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(mockMovieRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tMovies));
  });
}
