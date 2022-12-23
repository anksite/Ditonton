part of 'home_list_bloc.dart';

abstract class HomeListState extends Equatable {
  const HomeListState();
}

class MovieListInitial extends HomeListState {
  @override
  List<Object?> get props => [];
}

class PageTitle extends HomeListState {
  String value;
  PageTitle(this.value);

  @override
  List<Object?> get props => [value];
}

class NowState extends HomeListState {
  RequestState value;
  NowState(this.value);

  @override
  List<Object?> get props => [value];
}

class PopularState extends HomeListState {
  RequestState value;
  PopularState(this.value);

  @override
  List<Object?> get props => [value];
}

class TopRatedState extends HomeListState {
  RequestState value;
  TopRatedState(this.value);

   @override
  List<Object?> get props => [value];
}

class NowListData extends HomeListState {
  List<Movie> value;
  NowListData(this.value);

   @override
  List<Object?> get props => [value];
}

class PopularListData extends HomeListState {
  List<Movie> value;
  PopularListData(this.value);

   @override
  List<Object?> get props => [value];
}

class TopRatedListData extends HomeListState {
  List<Movie> value;
  TopRatedListData(this.value);

   @override
  List<Object?> get props => [value];
}
