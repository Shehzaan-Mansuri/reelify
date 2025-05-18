/*
 * byte_event.dart
 * 
 * This file defines all the events that can be dispatched to the ByteBloc.
 * Events represent user actions or system events that should trigger
 * state changes in the application.
 *
 * Using Equatable ensures that events with the same properties are considered equal,
 * which is important for testing and state management optimization.
 */

import 'package:equatable/equatable.dart';

/// Base class for all Byte-related events
///
/// Events are dispatched to the ByteBloc to trigger state changes.
/// All events extend Equatable to enable proper equality comparison based on properties.
abstract class ByteEvent extends Equatable {
  const ByteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch the initial page of bytes (videos)
///
/// This event is dispatched when:
/// - The app first loads the video feed
/// - The user performs a pull-to-refresh action
/// - The feed needs to be reset and reloaded from the beginning
class FetchInitialBytesEvent extends ByteEvent {
  /// Number of items to fetch per page
  final int limit;

  /// Creates an event to fetch the first page of bytes with the specified limit
  const FetchInitialBytesEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Event to fetch the next page of bytes (videos) for pagination
///
/// This event is dispatched when:
/// - The user scrolls near the end of the current list
/// - More content needs to be loaded for infinite scrolling
class FetchNextPageEvent extends ByteEvent {
  /// Number of items to fetch per page
  final int limit;

  /// Page number to fetch (1-based indexing)
  final int page;

  /// Creates an event to fetch a specific page of bytes with the specified limit
  const FetchNextPageEvent({required this.page, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}
