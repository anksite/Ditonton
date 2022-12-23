import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/detail/bloc/detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'bloc/is_watchlist_bloc.dart';

class DetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  late int id;
  late String kind;
  final List<String> arguments;

  DetailPage({required this.arguments}) {
    id = int.parse(arguments[0]);
    kind = arguments[1];
  }

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.kind == MOVIE) {
      context.read<DetailBloc>().add(FetchMovieDetail(widget.id));
    } else if (widget.kind == TV) {
      context.read<DetailBloc>().add(FetchTvDetail(widget.id));
    }

    context.read<IsWatchlistBloc>().add(LoadWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailBloc, DetailState>(
        buildWhen: (_, state) =>
            state is MovieLoading || state is MovieData || state is ErrorDetail,
        builder: (_, state) {
          print("DETAIL STATE 1 $state");
          if (state is MovieDetailInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieData) {
            final movie = state.value;
            return SafeArea(
              child: DetailContent(movie),
            );
          } else if (state is MovieRecommendations) {
            return Container();
          }
          else {
            return Text((state as ErrorDetail).value);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  DetailContent(this.movie);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title ?? movie.name!,
                              style: kHeading5,
                            ),
                            BlocConsumer<IsWatchlistBloc, IsWatchlistState>(
                              buildWhen: (_, state) =>
                                  state is IsWatchlist,
                              builder: (_, state) {
                                print("DETAIL STATE 3 $state");
                                if (state is IsWatchlist) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (!state.value) {
                                        context
                                            .read<IsWatchlistBloc>()
                                            .add(AddWatchlist(movie));
                                      } else {
                                        context
                                            .read<IsWatchlistBloc>()
                                            .add(RemoveFromWatchlist(movie));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.value
                                            ? Icon(Icons.check)
                                            : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Row();
                                }
                              },
                              listenWhen: (_, state) =>
                                  state is WatchlistMessage,
                              listener: (_, state) {
                                if (state is WatchlistMessage) {
                                  final message = state.value;
                                  if (message == 'Added to Watchlist' ||
                                      message == 'Removed from Watchlist') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(message),
                                          );
                                        });
                                  }
                                  context
                                      .read<IsWatchlistBloc>()
                                      .add(LoadWatchlistStatus(movie.id));
                                }
                              },
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<DetailBloc, DetailState>(
                              buildWhen: (_, state) =>
                                  state is RecommendationLoading ||
                                  state is ErrorRecomendation ||
                                  state is MovieRecommendations,
                              builder: (_, state) {
                                print("DETAIL STATE 2 $state");
                                if (state is RecommendationLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is ErrorRecomendation) {
                                  return Text(state.value);
                                } else if (state is MovieRecommendations) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.value[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              String kind;
                                              if (movie.title != null) {
                                                kind = MOVIE;
                                              } else {
                                                kind = TV;
                                              }

                                              Navigator.pushReplacementNamed(
                                                context,
                                                DetailPage.ROUTE_NAME,
                                                arguments: [
                                                  movie.id.toString(),
                                                  kind
                                                ],
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.value.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int? runtime) {
    if (runtime == null) {
      return "";
    } else {
      final int hours = runtime ~/ 60;
      final int minutes = runtime % 60;

      if (hours > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${minutes}m';
      }
    }
  }
}
