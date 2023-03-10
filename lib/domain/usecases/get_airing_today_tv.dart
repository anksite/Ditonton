import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetAiringTodayTv {
  final MovieRepository repository;

  GetAiringTodayTv(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getAiringTodayTv();
  }
}
