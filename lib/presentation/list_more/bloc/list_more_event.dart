part of 'list_more_bloc.dart';

abstract class ListMoreEvent {
  const ListMoreEvent();
}

class FetchMovies extends ListMoreEvent {
  String showedList;
  FetchMovies(this.showedList);
}
