import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/list_more/bloc/list_more_bloc.dart';
import 'package:ditonton/presentation/list_more/list_more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

class ListMoreEventFake extends Fake implements ListMoreEvent {}

class ListMoreStateFake extends Fake implements ListMoreState {}

class MockListMoreBloc extends MockBloc<ListMoreEvent, ListMoreState>
    implements ListMoreBloc {}

@GenerateMocks([ListMoreBloc])
void main() {
  late MockListMoreBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(ListMoreEventFake());
    registerFallbackValue(ListMoreStateFake());
  });

  setUp(() {
    mockBloc = MockListMoreBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<ListMoreBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(StateLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(
        _makeTestableWidget(ListMorePage(showedList: MOVIE_NOW_PLAYING)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(Movies(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(
        _makeTestableWidget(ListMorePage(showedList: MOVIE_NOW_PLAYING)));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(ErrorMessage('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(
        _makeTestableWidget(ListMorePage(showedList: MOVIE_NOW_PLAYING)));

    expect(textFinder, findsOneWidget);
  });
}
