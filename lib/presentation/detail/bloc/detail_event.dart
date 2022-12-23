part of 'detail_bloc.dart';

abstract class DetailEvent {
  const DetailEvent();
}

class FetchMovieDetail extends DetailEvent {
  int id;
  FetchMovieDetail(this.id);
}

class FetchTvDetail extends DetailEvent {
  int id;
  FetchTvDetail(this.id);
}
