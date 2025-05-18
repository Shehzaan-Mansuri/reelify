class Byte {
  /// Entity class representing a video byte in the application.
  ///
  /// A [Byte] contains metadata about a video including its source, metrics, owner information,
  /// and configuration settings.
  ///
  /// Properties:
  /// - [id]: Unique identifier for the byte
  /// - [title]: Display title of the byte
  /// - [url]: Original URL of the video
  /// - [cdnUrl]: Content Delivery Network URL for optimized delivery
  /// - [thumbCdnUrl]: CDN URL for the thumbnail image
  /// - [user]: Owner/creator of the byte
  /// - [category]: Category classification of the byte
  /// - [totalViews]: Count of total views
  /// - [totalLikes]: Count of likes received
  /// - [totalComments]: Count of comments on the byte
  /// - [totalShare]: Count of times the byte has been shared
  /// - [totalWishlist]: Count of users who added this to wishlist
  /// - [duration]: Length of the video in seconds
  /// - [byteAddedOn]: Timestamp when the byte was initially added
  /// - [byteUpdatedOn]: Timestamp when the byte was last updated (if any)
  /// - [bunnyStreamVideoId]: Identifier for Bunny.net video streaming service (if used)
  /// - [bytePlusVideoId]: Identifier for BytePlus video service (if used)
  /// - [language]: Language of the byte content
  /// - [orientation]: Video orientation (portrait/landscape)
  /// - [bunnyEncodingStatus]: Status code for Bunny.net encoding process
  /// - [deletedAt]: Timestamp when the byte was deleted (if applicable)
  /// - [videoHeight]: Height of the video in pixels
  /// - [videoWidth]: Width of the video in pixels
  /// - [location]: Geographic location associated with the byte (if any)
  /// - [isPrivate]: Flag indicating if the byte is private (1) or public (0)
  /// - [isHideComment]: Flag to control comment visibility (1 = hide, 0 = show)
  /// - [description]: Optional descriptive text for the byte
  /// - [archivedAt]: Timestamp when the byte was archived (if applicable)
  /// - [resolutions]: List of available video resolutions
  /// - [isLiked]: Flag indicating if the current user has liked the byte
  /// - [isWished]: Flag indicating if the current user has added to wishlist
  /// - [isFollow]: Flag indicating if the current user follows the byte creator
  /// - [metaDescription]: SEO metadata description
  /// - [metaKeywords]: SEO metadata keywords
  /// - [videoAspectRatio]: Aspect ratio of the video (e.g., "16:9")

  /// Entity class representing a user in the application.
  ///
  /// Contains basic user information and state related to the current context.
  ///
  /// Properties:
  /// - [userId]: Unique identifier for the user
  /// - [fullname]: User's full name
  /// - [username]: User's username/handle
  /// - [profilePicture]: URL to user's profile picture (if any)
  /// - [profilePictureCdn]: CDN URL for user's profile picture (if any)
  /// - [designation]: User's job title or role (if any)
  /// - [isSubscriptionActive]: Flag indicating if the user has an active subscription
  /// - [isFollow]: Flag indicating if the current user follows this user

  /// Entity class representing a content category.
  ///
  /// Simple entity class that classifies bytes into categories.
  ///
  /// Properties:
  /// - [title]: Name of the category

  /// Entity class representing a video resolution option.
  ///
  /// This class is a placeholder and should be expanded to include
  /// properties like width, height, bitrate, etc.
  final int id;
  final String title;
  final String url;
  final String cdnUrl;
  final String thumbCdnUrl;
  final User user;
  final Category category;
  final int totalViews;
  final int totalLikes;
  final int totalComments;
  final int totalShare;
  final int totalWishlist;
  final int duration;
  final DateTime byteAddedOn;
  final DateTime? byteUpdatedOn;
  final String? bunnyStreamVideoId;
  final String? bytePlusVideoId;
  final String language;
  final String orientation;
  final int bunnyEncodingStatus;
  final DateTime? deletedAt;
  final int videoHeight;
  final int videoWidth;
  final String? location;
  final int isPrivate;
  final int isHideComment;
  final String? description;
  final DateTime? archivedAt;
  final List<Resolution> resolutions;
  final bool isLiked;
  final bool isWished;
  final bool isFollow;
  final String? metaDescription;
  final String? metaKeywords;
  final String? videoAspectRatio;

  Byte({
    required this.id,
    required this.title,
    required this.url,
    required this.cdnUrl,
    required this.thumbCdnUrl,
    required this.user,
    required this.category,
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShare,
    required this.totalWishlist,
    required this.duration,
    required this.byteAddedOn,
    this.byteUpdatedOn,
    this.bunnyStreamVideoId,
    this.bytePlusVideoId,
    required this.language,
    required this.orientation,
    required this.bunnyEncodingStatus,
    this.deletedAt,
    required this.videoHeight,
    required this.videoWidth,
    this.location,
    required this.isPrivate,
    required this.isHideComment,
    this.description,
    this.archivedAt,
    required this.resolutions,
    required this.isLiked,
    required this.isWished,
    required this.isFollow,
    this.metaDescription,
    this.metaKeywords,
    this.videoAspectRatio,
  });
}

class User {
  final int userId;
  final String fullname;
  final String username;
  final String? profilePicture;
  final String? profilePictureCdn;
  final String? designation;
  final bool isSubscriptionActive;
  final bool isFollow;

  User({
    required this.userId,
    required this.fullname,
    required this.username,
    this.profilePicture,
    this.profilePictureCdn,
    this.designation,
    required this.isSubscriptionActive,
    required this.isFollow,
  });
}

class Category {
  final String title;

  Category({required this.title});
}

class Resolution {
  Resolution();
}
