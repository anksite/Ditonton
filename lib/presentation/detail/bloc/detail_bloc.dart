import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/get_tv_recommendations.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  DetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getTvDetail,
    required this.getTvRecommendations,
  }) : super(MovieDetailInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieLoading());

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);
      detailResult.fold(
        (failure) {
          emit(ErrorDetail(failure.message));
        },
        (movie) {
          emit(RecommendationLoading());
          emit(MovieData(movie));
          recommendationResult.fold(
            (failure) {
              emit(ErrorRecomendation(failure.message));
            },
            (movies) {
              emit(MovieRecommendations(movies));
            },
          );
        },
      );
    });

    on<FetchTvDetail>((event, emit) async {
      emit(MovieLoading());

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendations.execute(event.id);
      detailResult.fold(
        (failure) {
          emit(ErrorDetail(failure.message));
        },
        (movie) {
          emit(RecommendationLoading());
          emit(MovieData(movie));
          recommendationResult.fold(
            (failure) {
              emit(ErrorRecomendation(failure.message));
            },
            (movies) {
              emit(MovieRecommendations(movies));
            },
          );
        },
      );
    });
  }
}
