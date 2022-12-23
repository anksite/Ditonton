part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class FetchMovieSearch extends SearchEvent {
  String query;
  FetchMovieSearch(this.query);
}

class FetchTvSearch extends SearchEvent {
  String query;
  FetchTvSearch(this.query);
}
