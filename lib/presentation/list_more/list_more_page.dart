import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import 'bloc/list_more_bloc.dart';

class ListMorePage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';
  String showedList;

  ListMorePage({required this.showedList});

  @override
  _ListMorePageState createState() => _ListMorePageState();
}

class _ListMorePageState extends State<ListMorePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ListMoreBloc>(context, listen: false)
        .add(FetchMovies(widget.showedList));
  }

  @override
  Widget build(BuildContext context) {
    String title;

    if (widget.showedList == MOVIE_NOW_PLAYING) {
      title = "Now Playing Movie";
    } else if (widget.showedList == MOVIE_POPULAR) {
      title = "Popular Movie";
    } else if (widget.showedList == MOVIE_TOP_RATED) {
      title = "Top Rated Movie";
    } else if (widget.showedList == TV_AIRING_TODAY) {
      title = "Airing Today TV Show";
    } else if (widget.showedList == TV_POPULAR) {
      title = "Popular TV Show";
    } else {
      //if (widget.showedList == TV_TOP_RATED)
      title = "Top Rated TV Show";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ListMoreBloc, ListMoreState>(
          builder: (_, state) {
            print("ListMore State $state");
            if (state is ListMoreInitial) {
              //context.read<ListMoreBloc>().add(FetchMovies(widget.showedList));
              return Center(child: CircularProgressIndicator());
            } else if (state is StateLoading) {
              return Center(child: CircularProgressIndicator());
            } else if(state is ErrorMessage){
              return
                Center(key: Key('error_message'), child: Text(state.value));
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = (state as Movies).value[index];
                  return MovieCard(movie);
                },
                itemCount: (state as Movies).value.length,
              );
            }
          },
        ),
      ),
    );
  }
}
