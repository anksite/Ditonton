import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/about/about_page.dart';
import 'package:ditonton/presentation/detail/movie_detail_page.dart';
import 'package:ditonton/presentation/home/movie_list_notifier.dart';
import 'package:ditonton/presentation/list_more/list_more_page.dart';
import 'package:ditonton/presentation/search/search_page.dart';
import 'package:ditonton/presentation/watchlist/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  late String mKind;

  @override
  void initState() {
    super.initState();
    mKind = MOVIE;
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..setPageTitle("Movies")
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                mKind = MOVIE;
                Future.microtask(
                    () => Provider.of<MovieListNotifier>(context, listen: false)
                      ..setPageTitle("Movies")
                      ..fetchNowPlayingMovies()
                      ..fetchPopularMovies()
                      ..fetchTopRatedMovies());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Show'),
              onTap: () {
                mKind = TV;
                Future.microtask(
                    () => Provider.of<MovieListNotifier>(context, listen: false)
                      ..setPageTitle("TV Show")
                      ..fetchAiringTodayTv()
                      ..fetchPopularTv()
                      ..fetchTopRatedTv());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME,
                    arguments: MOVIE);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('TV Show Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME,
                    arguments: TV);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Consumer<MovieListNotifier>(builder: (context, data, child) {
          return Text(data.pageTitle);
        }),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME,
                  arguments: mKind);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () {
                  String arg;
                  if (mKind == MOVIE) {
                    arg = MOVIE_NOW_PLAYING;
                  } else {
                    arg = TV_AIRING_TODAY;
                  }

                  Navigator.pushNamed(context, ListMorePage.ROUTE_NAME,
                      arguments: arg);
                },
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.nowPlayingMovies, mKind);
                } else {
                  return Text('Failed');
                }
              }),
              SizedBox(height: 32),
              _buildSubHeading(
                  title: 'Popular',
                  onTap: () {
                    String arg;
                    if (mKind == MOVIE) {
                      arg = MOVIE_POPULAR;
                    } else {
                      arg = TV_POPULAR;
                    }

                    Navigator.pushNamed(context, ListMorePage.ROUTE_NAME,
                        arguments: arg);
                  }),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.popularMovies, mKind);
                } else {
                  return Text('Failed');
                }
              }),
              SizedBox(height: 32),
              _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () {
                    String arg;
                    if (mKind == MOVIE) {
                      arg = MOVIE_TOP_RATED;
                    } else {
                      arg = TV_TOP_RATED;
                    }

                    Navigator.pushNamed(context, ListMorePage.ROUTE_NAME,
                        arguments: arg);
                  }),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.topRatedMovies, mKind);
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final String kind;

  MovieList(this.movies, this.kind);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, MovieDetailPage.ROUTE_NAME,
                    arguments: [movie.id.toString(), kind]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
