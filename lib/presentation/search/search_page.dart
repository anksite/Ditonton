import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/search/bloc/search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  final String mKind;

  SearchPage({required this.mKind});

  @override
  Widget build(BuildContext context) {
    String title = "Search Movie";

    if (mKind == TV) {
      title = "Search TV Show";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (mKind == MOVIE) {
                  context.read<SearchBloc>().add(FetchMovieSearch(query));
                } else if (mKind == TV) {
                  context.read<SearchBloc>().add(FetchTvSearch(query));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (_, state){
                if (state is StateLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchResult) {
                  final result = state.value;
                  if (result.length == 0) {
                    return Expanded(
                      child: Center(
                        child: Text("No data", style: kSubtitle),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = state.value[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  }
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            )
            // Consumer<MovieSearchNotifier>(
            //   builder: (context, data, child) {
            //     if (data.state == RequestState.Loading) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (data.state == RequestState.Loaded) {
            //       final result = data.searchResult;
            //       if(result.length==0){
            //         return Expanded(
            //           child: Center(
            //             child: Text("No data", style: kSubtitle),
            //           ),
            //         );
            //       } else {
            //         return Expanded(
            //           child: ListView.builder(
            //             padding: const EdgeInsets.all(8),
            //             itemBuilder: (context, index) {
            //               final movie = data.searchResult[index];
            //               return MovieCard(movie);
            //             },
            //             itemCount: result.length,
            //           ),
            //         );
            //       }
            //
            //     } else {
            //       return Expanded(
            //         child: Container(),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
