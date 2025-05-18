import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/byte.dart';
import '../../utils/alert_utils.dart';
import 'gradient_overlay.dart';

/// A widget that displays a video item with interactive features for social media app.
///
/// The [VideoItem] widget provides a complete UI for video playback with social
/// features including:
/// - Play/pause functionality with tap
/// - Double-tap to like animation
/// - Hold to speed up playback
/// - Comments section accessible via bottom sheet
/// - Share functionality
/// - Like, comment, and share counters
/// - User information display
/// - Video progress indicator
///
/// ## Features:
/// - Handles video initialization and error states
/// - Displays thumbnail while video loads
/// - Supports tap gestures for various interactions
/// - Animated like button with heart animation
/// - Speed control with hold gesture
/// - Video progress bar at bottom
/// - Overlay with user info and engagement actions
///
/// ## Usage:
/// ```dart
/// VideoItem(
///   byte: byteObject,  // Contains video metadata and URLs
///   controller: videoPlayerController,  // Pre-initialized controller
/// )
/// ```
///
/// The controller should be managed externally to allow for preloading and
/// disposing of videos in list scenarios.
class VideoItem extends StatefulWidget {
  final Byte byte;
  final VideoPlayerController? controller;

  const VideoItem({super.key, required this.byte, this.controller});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem>
    with SingleTickerProviderStateMixin {
  bool _isHolding = false;
  bool _isLiked = false;
  AnimationController? _likeAnimationController;
  Animation<double>? _likeAnimation;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeAnimation = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(
          parent: _likeAnimationController!, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _likeAnimationController!.reverse();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _isLiked = false;
              });
            }
          });
        }
      });
  }

  Future<void> _initializeVideo() async {
    if (widget.controller != null && !widget.controller!.value.isInitialized) {
      try {
        await widget.controller!.initialize();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
            widget.controller!.setLooping(true);
          });
        }
      } catch (e) {
        AlertUtils.showErrorSnackBar(
            // ignore: use_build_context_synchronously
            context,
            'Error initializing video controller: $e');
      }
    } else if (widget.controller != null &&
        widget.controller!.value.isInitialized) {
      setState(() {
        _isVideoInitialized = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _isVideoInitialized = false;
      _initializeVideo();
    } else if (widget.controller != null &&
        widget.controller!.value.isInitialized &&
        !_isVideoInitialized) {
      setState(() {
        _isVideoInitialized = true;
        widget.controller!.setLooping(true);
      });
    }
  }

  @override
  void dispose() {
    _likeAnimationController?.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() {
      _isLiked = true;
      _likeAnimationController?.forward();
    });
  }

  void _handleSingleTap() {
    if (widget.controller != null && widget.controller!.value.isInitialized) {
      setState(() {
        if (widget.controller!.value.isPlaying) {
          widget.controller!.pause();
        } else {
          widget.controller!.play();
        }
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isHolding = true;
      if (widget.controller != null && widget.controller!.value.isInitialized) {
        widget.controller!.setPlaybackSpeed(2.0);
      }
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isHolding = false;
      if (widget.controller != null && widget.controller!.value.isInitialized) {
        widget.controller!.setPlaybackSpeed(1.0);
      }
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isHolding = false;
      if (widget.controller != null && widget.controller!.value.isInitialized) {
        widget.controller!.setPlaybackSpeed(1.0);
      }
    });
  }

  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Comments',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('This is where comments will be displayed.'),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(child: Text('U')),
                        title: Text('User $index'),
                        subtitle: const Text('A sample comment.'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    // Handle submitting the comment
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareVideo() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out this video!',
        uri: Uri.parse(widget.byte.cdnUrl),
      ),
    );
  }

  Widget _buildAppName() {
    return Positioned(
      top: 25,
      left: 16,
      child: Text(
        'Reelify',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLikeAnimationIcon() {
    return Positioned.fill(
      child: Center(
        child: ScaleTransition(
          scale: _likeAnimation!,
          child: const Icon(Icons.favorite, color: Colors.red, size: 80),
        ),
      ),
    );
  }

  Widget _buildPlayPauseIcon() {
    return const Positioned.fill(
      child: Center(
        child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Positioned(
      bottom: 50,
      left: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: widget.byte.user.profilePictureCdn != null
                ? NetworkImage(widget.byte.user.profilePictureCdn!)
                : null,
            child: widget.byte.user.profilePictureCdn == null
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            widget.byte.user.username,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoActions() {
    return Positioned(
      bottom: 80,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, color: Colors.white, size: 30),
          Text('${widget.byte.totalLikes}',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showCommentsBottomSheet(context),
            child: Column(
              children: [
                const Icon(Icons.comment_outlined,
                    color: Colors.white, size: 30),
                Text('${widget.byte.totalComments}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _shareVideo,
            child: Column(
              children: [
                const Icon(Icons.share_outlined, color: Colors.white, size: 30),
                Text('${widget.byte.totalShare}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDetails() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.byte.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          if (widget.byte.description != null &&
              widget.byte.description!.isNotEmpty)
            Text(
              widget.byte.description!,
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeedIndicator() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Icon(
            Icons.fast_forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVideoReady = widget.controller != null && _isVideoInitialized;

    return GestureDetector(
      onTap: _handleSingleTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: isVideoReady
                ? Center(
                    child: AspectRatio(
                      aspectRatio: widget.controller!.value.aspectRatio,
                      child: VideoPlayer(widget.controller!),
                    ),
                  )
                : Image.network(
                    widget.byte.thumbCdnUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                        child: Icon(Icons.error_outline,
                            color: Colors.white, size: 48),
                      );
                    },
                  ),
          ),
          const GradientOverlay(),
          _buildAppName(),
          if (_isLiked && _likeAnimation != null) _buildLikeAnimationIcon(),
          if (isVideoReady && !widget.controller!.value.isPlaying)
            _buildPlayPauseIcon(),
          _buildUserInfo(),
          _buildVideoActions(),
          _buildVideoDetails(),
          if (widget.controller != null && _isVideoInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                widget.controller!,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.white.withValues(alpha: 0.5),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          if (_isHolding) _buildSpeedIndicator(),
        ],
      ),
    );
  }
}
