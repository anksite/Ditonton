import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/pinning.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/about/about_page.dart';
import 'package:ditonton/presentation/detail/bloc/detail_bloc.dart';
import 'package:ditonton/presentation/detail/bloc/is_watchlist_bloc.dart';
import 'package:ditonton/presentation/detail/detail_page.dart';
import 'package:ditonton/presentation/home/bloc/home_list_bloc.dart';
import 'package:ditonton/presentation/home/home_page.dart';
import 'package:ditonton/presentation/list_more/bloc/list_more_bloc.dart';
import 'package:ditonton/presentation/list_more/list_more_page.dart';
import 'package:ditonton/presentation/search/bloc/search_bloc.dart';
import 'package:ditonton/presentation/search/search_page.dart';
import 'package:ditonton/presentation/watchlist/bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/watchlist/watchlist_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Pinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<HomeListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<IsWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<ListMoreBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
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
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());

            case ListMorePage.ROUTE_NAME:
              final showedList = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => ListMorePage(showedList: showedList),
                  settings: settings);

            case DetailPage.ROUTE_NAME:
              final arg = settings.arguments as List<String>;
              return MaterialPageRoute(
                builder: (_) => DetailPage(arguments: arg),
                settings: settings,
              );

            case SearchPage.ROUTE_NAME:
              final kind = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) =>
                      SearchPage(mKind: kind));

            case WatchlistPage.ROUTE_NAME:
              final kind = settings.arguments as String;
              return MaterialPageRoute(
                  builder: (_) => WatchlistPage(mKind: kind));

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
