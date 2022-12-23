import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/detail/bloc/detail_bloc.dart';
import 'package:ditonton/presentation/detail/bloc/is_watchlist_bloc.dart';
import 'package:ditonton/presentation/detail/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class DetailEventFake extends Fake implements DetailEvent {}

class DetailStateFake extends Fake implements DetailState {}

class MockDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements DetailBloc {}

class IsWatchlistEventFake extends Fake implements IsWatchlistEvent {}

class IsWatchlistStateFake extends Fake implements IsWatchlistState {}

class MockIsWatchlistBloc extends MockBloc<IsWatchlistEvent, IsWatchlistState>
    implements IsWatchlistBloc {}

@GenerateMocks([DetailBloc, IsWatchlistBloc])
void main() {
  late MockDetailBloc mockDetailBloc;
  late MockIsWatchlistBloc mockIsWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(DetailEventFake());
    registerFallbackValue(DetailStateFake());
    registerFallbackValue(IsWatchlistEventFake());
    registerFallbackValue(IsWatchlistStateFake());
  });

  setUp(() {
    mockDetailBloc = MockDetailBloc();
    mockIsWatchlistBloc = MockIsWatchlistBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailBloc>.value(value: mockDetailBloc),
        BlocProvider<IsWatchlistBloc>.value(value: mockIsWatchlistBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(MovieData(testMovieDetail));
    when(() => mockIsWatchlistBloc.state).thenReturn(IsWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester
        .pumpWidget(_makeTestableWidget(DetailPage(arguments: ["1", MOVIE])));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailBloc.state).thenReturn(MovieData(testMovieDetail));
    when(() => mockIsWatchlistBloc.state).thenReturn(IsWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester
        .pumpWidget(_makeTestableWidget(DetailPage(arguments: ["1", MOVIE])));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Duration text should not have data when displaying tv detail',
      (WidgetTester tester) async {
        when(() => mockDetailBloc.state).thenReturn(MovieData(testTvDetail));
        when(() => mockIsWatchlistBloc.state).thenReturn(IsWatchlist(false));

    await tester
        .pumpWidget(_makeTestableWidget(DetailPage(arguments: ["1", TV])));

    expect(find.text(''), findsOneWidget);
  });
}
