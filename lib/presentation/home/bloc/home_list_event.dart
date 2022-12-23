part of 'home_list_bloc.dart';

abstract class HomeListEvent {
  const HomeListEvent();
}

class SetPageTitle extends HomeListEvent {
  String pageTitle;

  SetPageTitle(this.pageTitle);
}

class FetchNowPlayingMovies extends HomeListEvent {}

class FetchPopularMovies extends HomeListEvent {}

class FetchTopRatedMovies extends HomeListEvent {}

class FetchAiringTodayTv extends HomeListEvent {}

class FetchPopularTv extends HomeListEvent {}

class FetchTopRatedTv extends HomeListEvent {}
