import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetTvDetail {
  final MovieRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
