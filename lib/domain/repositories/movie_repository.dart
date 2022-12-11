import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

abstract class MovieRepository {
  //movie
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();

  Future<Either<Failure, List<Movie>>> getPopularMovies();

  Future<Either<Failure, List<Movie>>> getTopRatedMovies();

  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);

  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);

  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  //tv
  Future<Either<Failure, List<Movie>>> getAiringTodayTv();

  Future<Either<Failure, List<Movie>>> getPopularTv();

  Future<Either<Failure, List<Movie>>> getTopRatedTv();

  Future<Either<Failure, MovieDetail>> getTvDetail(int id);

  Future<Either<Failure, List<Movie>>> getTvRecommendations(int id);

  Future<Either<Failure, List<Movie>>> searchTv(String query);

  //local
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);

  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<Movie>>> getWatchlistMovies(String kind);
}
