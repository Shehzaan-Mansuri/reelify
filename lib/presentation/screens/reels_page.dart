/*
 * reels_page.dart
 * 
 * This file implements the main Reels screen of the application, which displays
 * short-form video content in a vertical scrolling format similar to TikTok, 
 * Instagram Reels, or YouTube Shorts.
 * 
 * Key features:
 * - Vertical swipe navigation between videos
 * - Video preloading and caching for smooth playback
 * - Memory management by disposing unused video controllers
 * - Pull-to-refresh functionality 
 * - Automatic pagination when reaching the end of available content
 * - Video playback control based on visibility
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../domain/entities/byte.dart';
import '../bloc/byte_bloc/byte_bloc.dart';
import '../bloc/byte_bloc/byte_event.dart';
import '../bloc/byte_bloc/byte_state.dart';
import '../widgets/video_item.dart';

/// ReelsPage is the main screen that displays short-form video content
/// in a vertically scrollable format.
class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  // Controller for handling page swipes
  final _pageController = PageController();

  // Cache of video controllers to prevent recreating them when revisiting a video
  final Map<int, VideoPlayerController> _videoControllers = {};

  // Manager for caching video files to reduce network usage and improve performance
  final CacheManager _cacheManager = DefaultCacheManager();

  // Track the currently visible page index
  int _currentPageIndex = 0;

  // Flag to prevent multiple simultaneous pagination requests
  bool _isFetchingNextPage = false;

  /// Downloads and caches a video file for smoother playback
  ///
  /// This improves user experience by reducing buffering times
  /// for videos that may be viewed soon.
  Future<void> _cacheVideo(String url) async {
    await _cacheManager.downloadFile(url);
  }

  /// Creates and initializes a VideoPlayerController for the specified video
  ///
  /// This method:
  /// 1. Creates a controller if it doesn't exist already
  /// 2. Initializes the controller (prepares the video)
  /// 3. Automatically plays and loops the video if it's the current one
  Future<void> _initializeVideoController(String url, int index) async {
    if (!_videoControllers.containsKey(index)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _videoControllers[index] = controller;
      await controller.initialize();
      if (mounted && index == _currentPageIndex) {
        controller.play();
        controller.setLooping(true);
      }
    }
  }

  /// Preloads videos that are likely to be viewed next
  ///
  /// Implements a smart preloading strategy that:
  /// - Loads the current video
  /// - Preloads the next two videos
  /// - Preloads the previous video (in case user swipes back)
  void _preloadVideos(List<Byte> bytes) {
    final indicesToCache = <int>{
      _currentPageIndex,
      _currentPageIndex + 1,
      _currentPageIndex + 2,
      _currentPageIndex - 1,
    };

    for (final index in indicesToCache) {
      if (index >= 0 && index < bytes.length) {
        _cacheVideo(bytes[index].cdnUrl);
        if (!_videoControllers.containsKey(index)) {
          _initializeVideoController(bytes[index].cdnUrl, index);
        }
      }
    }
  }

  /// Handles video playback when user swipes to a new video
  ///
  /// This method:
  /// 1. Pauses and resets the previously playing video
  /// 2. Updates the current page index
  /// 3. Plays the newly visible video
  /// 4. Preloads adjacent videos for smooth navigation
  /// 5. Triggers pagination when reaching the end of the list
  /// 6. Cleans up controllers for videos that are far from view
  void _onPageChanged(int index, List<Byte> bytes) {
    setState(() {
      // Pause the previous video
      final previousController = _videoControllers[_currentPageIndex];
      previousController?.pause();
      previousController?.seekTo(Duration.zero);

      _currentPageIndex = index;

      // Play the current video if its controller is initialized
      if (_videoControllers.containsKey(_currentPageIndex)) {
        _videoControllers[_currentPageIndex]!.play();
      } else {
        // Initialize and play if not already initialized
        _initializeVideoController(
            bytes[_currentPageIndex].cdnUrl, _currentPageIndex);
      }
      _preloadVideos(bytes);

      // Fetch next page automatically when near the end of content
      if (index == bytes.length - 1 &&
          !_isFetchingNextPage &&
          context.read<ByteBloc>().state is ByteLoadedState &&
          !(context.read<ByteBloc>().state as ByteLoadedState).hasReachedMax) {
        _isFetchingNextPage = true;
        context.read<ByteBloc>().add(
            FetchNextPageEvent(page: context.read<ByteBloc>().currentPage + 1));
      }

      // Memory management: dispose controllers for videos far from view
      // to prevent excessive memory usage
      final keysToRemove = _videoControllers.keys
          .where((key) => (key - _currentPageIndex).abs() > 2)
          .toList();
      for (final key in keysToRemove) {
        _videoControllers[key]?.dispose();
        _videoControllers.remove(key);
      }
    });
  }

  /// Refreshes the feed with new content when user pulls down
  ///
  /// This method:
  /// 1. Pauses and resets all active video controllers
  /// 2. Clears the controller cache
  /// 3. Requests fresh data from the ByteBloc
  /// 4. Returns a Future that completes when loading finishes
  Future<Future<ByteState>> _refreshReels() async {
    for (var controller in _videoControllers.values) {
      controller.pause();
      controller.seekTo(Duration.zero);
    }
    _videoControllers.clear();
    context.read<ByteBloc>().add(FetchInitialBytesEvent());
    return context
        .read<ByteBloc>()
        .stream
        .firstWhere((state) => state is! ByteLoadingState);
  }

  @override
  void dispose() {
    // Clean up resources when widget is removed from the tree
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _cacheManager.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ByteBloc, ByteState>(
        listener: (context, state) {
          // Reset pagination flag when loading completes
          if (state is! ByteLoadingState) {
            _isFetchingNextPage = false;
          }

          // Initialize first video when data is initially loaded
          if (state is ByteLoadedState &&
              _videoControllers.isEmpty &&
              state.bytes.isNotEmpty) {
            _initializeVideoController(state.bytes[0].cdnUrl, 0);
            _preloadVideos(state.bytes);
          }
        },
        builder: (context, state) {
          // Show loading indicator when initially fetching data
          if (state is ByteLoadingState && state.bytes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show content when data is available or being refreshed
          else if (state is ByteLoadedState || state is ByteLoadingState) {
            final bytes = state is ByteLoadedState
                ? state.bytes
                : (state as ByteLoadingState).bytes;
            return RefreshIndicator(
              onRefresh: _refreshReels,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: bytes.length,
                    itemBuilder: (context, index) {
                      final byte = bytes[index];
                      return _buildVideoItemWithVisibility(byte, index);
                    },
                    onPageChanged: (index) => _onPageChanged(index, bytes),
                  ),
                ],
              ),
            );
          }
          // Show error message if data fetching failed
          else if (state is ByteErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Fallback for any unexpected states
          else {
            return const Center(child: Text('Initial state'));
          }
        },
      ),
    );
  }

  /// Creates a video item wrapped in a visibility detector
  ///
  /// The visibility detector automatically controls video playback
  /// based on how much of the video is visible on screen:
  /// - Plays when mostly visible (>70%)
  /// - Pauses and resets when not visible enough
  Widget _buildVideoItemWithVisibility(Byte byte, int index) {
    return VisibilityDetector(
      key: Key('video-item-$index'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.7) {
          if (_videoControllers.containsKey(index) &&
              !_videoControllers[index]!.value.isPlaying) {
            _videoControllers[index]!.play();
          }
        } else {
          if (_videoControllers.containsKey(index) &&
              _videoControllers[index]!.value.isPlaying) {
            _videoControllers[index]!.pause();
            _videoControllers[index]!.seekTo(Duration.zero);
          }
        }
      },
      child: VideoItem(
        byte: byte,
        controller: _videoControllers[index],
      ),
    );
  }
}
