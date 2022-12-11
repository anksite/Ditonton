import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/list_more/list_more_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';

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
    Future.microtask(() => Provider.of<ListMoreNotifier>(context, listen: false)
        .fetchMovies(widget.showedList));
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
        child: Consumer<ListMoreNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.movies[index];
                  return MovieCard(movie);
                },
                itemCount: data.movies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
