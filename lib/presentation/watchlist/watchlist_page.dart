import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/watchlist/bloc/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../detail/detail_page.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  final String mKind;

  WatchlistPage({required this.mKind});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(FetchWatchlistMovies(widget.mKind));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    String title = "Movie Watchlist";

    if (widget.mKind == TV) {
      title = "TV Show Watchlist";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (_, state) {
            print("STATE $state");
            if (state is StateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistMovies) {
              if (state.value.length == 0) {
                return Center(
                  child: Text(
                    "No data",
                    style: kSubtitle,
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final movie = state.value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            DetailPage.ROUTE_NAME,
                            arguments: [movie.id.toString(), widget.mKind],
                          ).then((value) => context
                              .read<WatchlistBloc>()
                              .add(FetchWatchlistMovies(widget.mKind)));
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Card(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 16 + 80 + 16,
                                  bottom: 8,
                                  right: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title ?? movie.name ?? '-',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kHeading6,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      movie.overview ?? '-',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 16,
                                bottom: 16,
                              ),
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '$BASE_IMAGE_URL${movie.posterPath}',
                                  width: 80,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state.value.length,
                );
              }
            } else if (state is ErrorMessage) {
              return Center(
                key: Key('error_message'),
                child: Text(state.value),
              );
            } else {
              //WatchlistInitial State
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
