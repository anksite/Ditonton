import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/about/about_page.dart';
import 'package:ditonton/presentation/detail/movie_detail_notifier.dart';
import 'package:ditonton/presentation/detail/movie_detail_page.dart';
import 'package:ditonton/presentation/home/home_movie_page.dart';
import 'package:ditonton/presentation/home/movie_list_notifier.dart';
import 'package:ditonton/presentation/list_more/list_more_notifier.dart';
import 'package:ditonton/presentation/list_more/list_more_page.dart';
import 'package:ditonton/presentation/search/movie_search_notifier.dart';
import 'package:ditonton/presentation/search/search_page.dart';
import 'package:ditonton/presentation/watchlist/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/watchlist/watchlist_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ListMoreNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());

            case ListMorePage.ROUTE_NAME:
              final showedList = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => ListMorePage(showedList: showedList),
                  settings: settings);

            case MovieDetailPage.ROUTE_NAME:
              final arg = settings.arguments as List<String>;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(arguments: arg),
                settings: settings,
              );

            case SearchPage.ROUTE_NAME:
              final kind = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => SearchPage(
                        mKind: kind,
                      ));

            case WatchlistMoviesPage.ROUTE_NAME:
              final kind = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => WatchlistMoviesPage(mKind: kind));

            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());

            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
