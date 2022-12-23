part of 'list_more_bloc.dart';

abstract class ListMoreState extends Equatable {
  const ListMoreState();
}

class ListMoreInitial extends ListMoreState {
  @override
  List<Object> get props => [];
}

class StateLoading extends ListMoreState {
  @override
  List<Object?> get props => [];
}

class ErrorMessage extends ListMoreState {
  String value;
  ErrorMessage(this.value);

  @override
  List<Object?> get props => [value];
}

class Movies extends ListMoreState {
  List<Movie> value;
  Movies(this.value);

  @override
  List<Object?> get props => [value];
}
