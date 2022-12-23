import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/about/about_page.dart';
import 'package:ditonton/presentation/detail/detail_page.dart';
import 'package:ditonton/presentation/list_more/list_more_page.dart';
import 'package:ditonton/presentation/search/search_page.dart';
import 'package:ditonton/presentation/watchlist/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_list_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String mKind;

  @override
  void initState() {
    super.initState();
    mKind = MOVIE;
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

                context.read<HomeListBloc>().add(SetPageTitle("Movies"));
                context.read<HomeListBloc>().add(FetchNowPlayingMovies());
                context.read<HomeListBloc>().add(FetchPopularMovies());
                context.read<HomeListBloc>().add(FetchTopRatedMovies());

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Show'),
              onTap: () {
                mKind = TV;

                context.read<HomeListBloc>().add(SetPageTitle("TV Show"));
                context.read<HomeListBloc>().add(FetchAiringTodayTv());
                context.read<HomeListBloc>().add(FetchPopularTv());
                context.read<HomeListBloc>().add(FetchTopRatedTv());

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME,
                    arguments: MOVIE);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('TV Show Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME,
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
        title: BlocBuilder<HomeListBloc, HomeListState>(
          buildWhen: (_, state) {
            return state is PageTitle;
          },
          builder: (context, state) {
            if (state is MovieListInitial) {
              return Text("Movies");
            } else {
              return Text((state as PageTitle).value);
            }
          },
        ),
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
              BlocBuilder<HomeListBloc, HomeListState>(
                buildWhen: (_, state) =>
                    state is NowState || state is NowListData,
                builder: (_, state) {
                  if (state is MovieListInitial) {
                    context.read<HomeListBloc>().add(FetchNowPlayingMovies());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NowState) {
                    if (state.value == RequestState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text('Failed');
                    }
                  } else {
                    return MovieList((state as NowListData).value, mKind);
                  }
                },
              ),
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
              BlocBuilder<HomeListBloc, HomeListState>(
                buildWhen: (_, state) =>
                state is PopularState || state is PopularListData,
                builder: (_, state) {
                  if (state is MovieListInitial) {
                    context.read<HomeListBloc>().add(FetchPopularMovies());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PopularState) {
                    if (state.value == RequestState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text('Failed');
                    }
                  } else {
                    return MovieList((state as PopularListData).value, mKind);
                  }
                },
              ),
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
              BlocBuilder<HomeListBloc, HomeListState>(
                buildWhen: (_, state) =>
                state is TopRatedState || state is TopRatedListData,
                builder: (_, state) {
                  if (state is MovieListInitial) {
                    context.read<HomeListBloc>().add(FetchTopRatedMovies());
                    return Center(child: CircularProgressIndicator());
                  } else if (state is TopRatedState) {
                    if (state.value == RequestState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text('Failed');
                    }
                  } else {
                    return MovieList((state as TopRatedListData).value, mKind);
                  }
                },
              ),
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
                Navigator.pushNamed(context, DetailPage.ROUTE_NAME,
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
