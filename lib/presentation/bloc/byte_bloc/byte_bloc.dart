/*
 * byte_bloc.dart
 * 
 * This file implements the state management logic for the "Bytes" (short videos)
 * feature using the BLoC (Business Logic Component) pattern. It handles:
 *
 * - Initial data loading
 * - Pagination (infinite scrolling)
 * - Maintaining the current state of the video feed
 * - Error handling for data fetching failures
 *
 * The BLoC pattern separates business logic from UI, making the code more
 * testable, maintainable, and adhering to separation of concerns principles.
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/byte.dart';
import '../../../domain/use_cases/fetch_bytes_use_case.dart';
import 'byte_event.dart';
import 'byte_state.dart';

/// Manages state for the Bytes feature (short-form videos)
///
/// This BLoC handles loading, pagination, and error states for the video feed.
/// It communicates with the domain layer through use cases, following clean
/// architecture principles to keep business logic separate from UI concerns.
class ByteBloc extends Bloc<ByteEvent, ByteState> {
  // UseCase dependency for fetching video data
  final FetchBytesUseCase _fetchBytesUseCase;

  // Current pagination state
  int _currentPage = 1;
  bool _hasReachedMax = false;

  // In-memory cache of all loaded bytes
  final List<Byte> _bytes = [];

  /// Creates a ByteBloc with the necessary use case dependency
  ///
  /// Registers event handlers for the different events this bloc can receive.
  ByteBloc(this._fetchBytesUseCase) : super(ByteInitialState()) {
    on<FetchInitialBytesEvent>(_onFetchInitialBytes);
    on<FetchNextPageEvent>(_onFetchNextPage);
  }

  /// Public getter for the current page number
  /// Used by UI to track pagination progress
  int get currentPage => _currentPage;

  /// Public getter for the current list of bytes (videos)
  /// Returns an unmodifiable list to prevent external modifications
  List<Byte> get bytes => List.unmodifiable(_bytes);

  /// Handles the initial data loading
  ///
  /// This method:
  /// 1. Emits a loading state
  /// 2. Resets pagination state
  /// 3. Clears any existing data
  /// 4. Fetches the first page of data
  /// 5. Emits either a loaded state or an error state
  Future<void> _onFetchInitialBytes(
      FetchInitialBytesEvent event, Emitter<ByteState> emit) async {
    // Indicate loading state with empty data
    emit(ByteLoadingState(bytes: List.empty()));

    // Reset pagination state
    _currentPage = 1;
    _hasReachedMax = false;
    _bytes.clear();

    try {
      // Fetch first page of data
      final newBytes =
          await _fetchBytesUseCase.execute(_currentPage, event.limit);

      // Update internal state
      _bytes.addAll(newBytes);
      _hasReachedMax = newBytes.isEmpty;

      // Emit success state
      emit(ByteLoadedState(
          bytes: List.from(_bytes), hasReachedMax: _hasReachedMax));
    } catch (e) {
      // Emit error state if data fetching fails
      emit(ByteErrorState(message: e.toString()));
    }
  }

  /// Handles pagination (loading the next page of data)
  ///
  /// This method:
  /// 1. Checks if we can load more data
  /// 2. Emits a loading state (while preserving current data)
  /// 3. Increments the page counter
  /// 4. Fetches the next page of data
  /// 5. Updates the "reached max" flag based on results
  /// 6. Emits either a loaded state or an error state
  Future<void> _onFetchNextPage(
      FetchNextPageEvent event, Emitter<ByteState> emit) async {
    // Only proceed if we're in a loaded state and haven't reached the end
    if (state is ByteLoadedState && !(state as ByteLoadedState).hasReachedMax) {
      // Indicate loading while preserving existing data
      emit(ByteLoadingState(bytes: List.from(_bytes)));

      // Move to next page
      _currentPage++;

      try {
        // Fetch next page of data
        final newBytes =
            await _fetchBytesUseCase.execute(_currentPage, event.limit);

        // Update internal state
        if (newBytes.isEmpty) {
          _hasReachedMax = true;
        } else {
          _bytes.addAll(newBytes);
        }

        // Emit success state
        emit(ByteLoadedState(
            bytes: List.from(_bytes), hasReachedMax: _hasReachedMax));
      } catch (e) {
        // Emit error state if data fetching fails
        emit(ByteErrorState(message: e.toString()));
      }
    }
  }
}
