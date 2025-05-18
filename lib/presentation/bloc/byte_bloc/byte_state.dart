/*
 * byte_state.dart
 * 
 * This file defines all possible states of the ByteBloc that represent
 * different phases in the content loading lifecycle. The states are:
 *
 * - ByteInitialState: Initial state before any loading has begun
 * - ByteLoadingState: Loading is in progress (initial or pagination)
 * - ByteLoadedState: Content is successfully loaded and ready to display
 * - ByteErrorState: An error occurred during loading
 *
 * Using Equatable for states ensures that state comparisons are based on content
 * rather than identity, which is important for proper BLoC operation.
 */

import 'package:equatable/equatable.dart';
import '../../../domain/entities/byte.dart';

/// Base abstract class for all Byte-related states
///
/// All concrete states must extend this class to ensure consistency
/// in how state transitions are handled in the ByteBloc.
abstract class ByteState extends Equatable {
  const ByteState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any content loading has started
///
/// This state is used when the ByteBloc is first created and
/// no data fetching has been initiated yet.
class ByteInitialState extends ByteState {
  const ByteInitialState();
}

/// State representing that content is being loaded
///
/// This state is emitted:
/// - During initial loading (with empty bytes list)
/// - During pagination (with the current bytes list to show existing content)
///
/// Having the current bytes in the loading state allows the UI to show
/// existing content while loading more, improving user experience.
class ByteLoadingState extends ByteState {
  /// Current list of bytes to display while loading more
  final List<Byte> bytes;

  const ByteLoadingState({this.bytes = const []});

  @override
  List<Object?> get props => [bytes];
}

/// State representing that content is successfully loaded
///
/// This state contains:
/// - The current list of all loaded bytes
/// - A flag indicating if we've reached the end of available content
///
/// This state is the "stable" state where content is ready for display.
class ByteLoadedState extends ByteState {
  /// List of all loaded video content
  final List<Byte> bytes;

  /// Flag indicating whether we've reached the end of available content
  /// Used to determine whether to show loading indicators or attempt pagination
  final bool hasReachedMax;

  const ByteLoadedState({required this.bytes, this.hasReachedMax = false});

  /// Creates a copy of this state with optional updated properties
  ///
  /// This is useful for creating new states with minimal changes
  /// without having to specify all properties every time.
  ByteLoadedState copyWith({
    List<Byte>? bytes,
    bool? hasReachedMax,
  }) {
    return ByteLoadedState(
      bytes: bytes ?? this.bytes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [bytes, hasReachedMax];
}

/// State representing that an error occurred during content loading
///
/// This state is emitted when:
/// - Network requests fail
/// - API returns errors
/// - Data parsing fails
///
/// The error message can be displayed to the user or logged for debugging.
class ByteErrorState extends ByteState {
  /// Human-readable error message describing what went wrong
  final String message;

  const ByteErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
