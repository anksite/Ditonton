import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'is_watchlist_event.dart';

part 'is_watchlist_state.dart';

class IsWatchlistBloc extends Bloc<IsWatchlistEvent, IsWatchlistState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  IsWatchlistBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  })
      : super(IsWatchlist(false)) {
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(IsWatchlist(result));
    });

    on<AddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(WatchlistMessage(failure.message));
        },
        (successMessage) async {
          print("emit WatchlistMessage $successMessage");
          emit(WatchlistMessage(successMessage));
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(WatchlistMessage(failure.message));
        },
        (successMessage) async {
          emit(WatchlistMessage(successMessage));
        },
      );
    });
  }
}
