part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();
}

class MovieDetailInitial extends DetailState {
  @override
  List<Object> get props => [];
}

class MovieData extends DetailState {
  MovieDetail value;
  MovieData(this.value);

  @override
  List<Object> get props => [value];
}

class MovieLoading extends DetailState {
  @override
  List<Object> get props => [];
}

class MovieRecommendations extends DetailState {
  List<Movie> value;
  MovieRecommendations(this.value);

  @override
  List<Object> get props => [value];
}

class RecommendationLoading extends DetailState {
  @override
  List<Object> get props => [];
}

class ErrorDetail extends DetailState {
  String value;
  ErrorDetail(this.value);

  @override
  List<Object> get props => [value];
}

class ErrorRecomendation extends DetailState {
  String value;
  ErrorRecomendation(this.value);

  @override
  List<Object> get props => [value];
}