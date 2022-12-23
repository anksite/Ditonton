part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class StateLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchResult extends SearchState {
  List<Movie> value;
  SearchResult(this.value);

  @override
  List<Object?> get props => [value];
}

class ErrorMessage extends SearchState {
  String value;
  ErrorMessage(this.value);

  @override
  List<Object?> get props => [value];
}