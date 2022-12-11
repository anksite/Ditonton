// Mocks generated by Mockito 5.3.0 from annotations
// in ditonton/test/presentation/pages/list_more_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i11;
import 'dart:ui' as _i12;

import 'package:ditonton/common/state_enum.dart' as _i9;
import 'package:ditonton/domain/entities/movie.dart' as _i10;
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart' as _i5;
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart' as _i2;
import 'package:ditonton/domain/usecases/get_popular_movies.dart' as _i3;
import 'package:ditonton/domain/usecases/get_popular_tv.dart' as _i6;
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart' as _i4;
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart' as _i7;
import 'package:ditonton/presentation/list_more/list_more_notifier.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetNowPlayingMovies_0 extends _i1.SmartFake
    implements _i2.GetNowPlayingMovies {
  _FakeGetNowPlayingMovies_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetPopularMovies_1 extends _i1.SmartFake
    implements _i3.GetPopularMovies {
  _FakeGetPopularMovies_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetTopRatedMovies_2 extends _i1.SmartFake
    implements _i4.GetTopRatedMovies {
  _FakeGetTopRatedMovies_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetAiringTodayTv_3 extends _i1.SmartFake
    implements _i5.GetAiringTodayTv {
  _FakeGetAiringTodayTv_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetPopularTv_4 extends _i1.SmartFake implements _i6.GetPopularTv {
  _FakeGetPopularTv_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeGetTopRatedTv_5 extends _i1.SmartFake implements _i7.GetTopRatedTv {
  _FakeGetTopRatedTv_5(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [ListMoreNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockListMoreNotifier extends _i1.Mock implements _i8.ListMoreNotifier {
  MockListMoreNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetNowPlayingMovies get getNowPlayingMovies =>
      (super.noSuchMethod(Invocation.getter(#getNowPlayingMovies),
              returnValue: _FakeGetNowPlayingMovies_0(
                  this, Invocation.getter(#getNowPlayingMovies)))
          as _i2.GetNowPlayingMovies);

  @override
  _i3.GetPopularMovies get getPopularMovies => (super.noSuchMethod(
      Invocation.getter(#getPopularMovies),
      returnValue: _FakeGetPopularMovies_1(
          this, Invocation.getter(#getPopularMovies))) as _i3.GetPopularMovies);

  @override
  _i4.GetTopRatedMovies get getTopRatedMovies =>
      (super.noSuchMethod(Invocation.getter(#getTopRatedMovies),
              returnValue: _FakeGetTopRatedMovies_2(
                  this, Invocation.getter(#getTopRatedMovies)))
          as _i4.GetTopRatedMovies);

  @override
  _i5.GetAiringTodayTv get getAiringTodayTv => (super.noSuchMethod(
      Invocation.getter(#getAiringTodayTv),
      returnValue: _FakeGetAiringTodayTv_3(
          this, Invocation.getter(#getAiringTodayTv))) as _i5.GetAiringTodayTv);

  @override
  _i6.GetPopularTv get getPopularTv =>
      (super.noSuchMethod(Invocation.getter(#getPopularTv),
              returnValue:
                  _FakeGetPopularTv_4(this, Invocation.getter(#getPopularTv)))
          as _i6.GetPopularTv);

  @override
  _i7.GetTopRatedTv get getTopRatedTv =>
      (super.noSuchMethod(Invocation.getter(#getTopRatedTv),
              returnValue:
                  _FakeGetTopRatedTv_5(this, Invocation.getter(#getTopRatedTv)))
          as _i7.GetTopRatedTv);

  @override
  _i9.RequestState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _i9.RequestState.Empty) as _i9.RequestState);

  @override
  List<_i10.Movie> get movies => (super.noSuchMethod(Invocation.getter(#movies),
      returnValue: <_i10.Movie>[]) as List<_i10.Movie>);

  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);

  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);

  @override
  _i11.Future<void> fetchMovies(String? showedList) =>
      (super.noSuchMethod(Invocation.method(#fetchPopularMovies, [showedList]),
              returnValue: _i11.Future<void>.value(),
              returnValueForMissingStub: _i11.Future<void>.value())
          as _i11.Future<void>);

  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);

  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);

  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);

  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}