import '../../domain/entities/byte.dart';

/// Model class for representing a byte content in the application.
///
/// [ByteModel] handles the data layer representation of a byte, including
/// serialization from JSON and conversion to domain entity.
/// It contains various properties related to a byte such as video details,
/// user information, statistics (views, likes, etc.), and metadata.
///
/// Properties:
/// - Basic information: id, title, url, description
/// - Media details: cdnUrl, thumbCdnUrl, duration, videoHeight, videoWidth
/// - User and category information
/// - Statistics: totalViews, totalLikes, totalComments, totalShare, totalWishlist
/// - Stream identifiers: bunnyStreamVideoId, bytePlusVideoId
/// - Metadata: language, orientation, location, videoAspectRatio
/// - Status flags: isPrivate, isHideComment, isLiked, isWished, isFollow
/// - Technical details: bunnyEncodingStatus, resolutions
/// - Timestamps: byteAddedOn, byteUpdatedOn, deletedAt, archivedAt
///
/// The class provides:
/// - A constructor for creating instances with required and optional parameters
/// - A factory method [fromJson] to deserialize JSON data
/// - A [toDomain] method to convert the model to its domain entity representation
///
/// Related models:
/// - [UserModel]: Represents user information associated with the byte
/// - [CategoryModel]: Represents the category the byte belongs to
/// - [ResolutionModel]: Represents available video resolutions
class ByteModel {
  final int id;
  final String title;
  final String url;
  final String cdnUrl;
  final String thumbCdnUrl;
  final UserModel user;
  final CategoryModel category;
  final int totalViews;
  final int totalLikes;
  final int totalComments;
  final int totalShare;
  final int totalWishlist;
  final int duration;
  final String byteAddedOn;
  final String? byteUpdatedOn;
  final String? bunnyStreamVideoId;
  final String? bytePlusVideoId;
  final String language;
  final String orientation;
  final int bunnyEncodingStatus;
  final String? deletedAt;
  final int videoHeight;
  final int videoWidth;
  final String? location;
  final int isPrivate;
  final int isHideComment;
  final String? description;
  final String? archivedAt;
  final List<ResolutionModel> resolutions;
  final bool isLiked;
  final bool isWished;
  final bool isFollow;
  final String? metaDescription;
  final String? metaKeywords;
  final String? videoAspectRatio;

  ByteModel({
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

  factory ByteModel.fromJson(Map<String, dynamic> json) {
    return ByteModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      cdnUrl: json['cdn_url'] ?? '',
      thumbCdnUrl: json['thumb_cdn_url'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      category: CategoryModel.fromJson(json['category'] ?? {}),
      totalViews: json['total_views'] ?? 0,
      totalLikes: json['total_likes'] ?? 0,
      totalComments: json['total_comments'] ?? 0,
      totalShare: json['total_share'] ?? 0,
      totalWishlist: json['total_wishlist'] ?? 0,
      duration: json['duration'] ?? 0,
      byteAddedOn: json['byte_added_on'] ?? '',
      byteUpdatedOn: json['byte_updated_on'],
      bunnyStreamVideoId: json['bunny_stream_video_id'],
      bytePlusVideoId: json['byte_plus_video_id'],
      language: json['language'] ?? '',
      orientation: json['orientation'] ?? '',
      bunnyEncodingStatus: json['bunny_encoding_status'] ?? 0,
      deletedAt: json['deleted_at'],
      videoHeight: json['video_height'] ?? 0,
      videoWidth: json['video_width'] ?? 0,
      location: json['location'],
      isPrivate: json['is_private'] ?? 0,
      isHideComment: json['is_hide_comment'] ?? 0,
      description: json['description'],
      archivedAt: json['archived_at'],
      resolutions: (json['resolutions'] as List?)
              ?.map((r) => ResolutionModel.fromJson(r))
              .toList() ??
          [],
      isLiked: json['is_liked'] ?? false,
      isWished: json['is_wished'] ?? false,
      isFollow: json['is_follow'] ?? false,
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
      videoAspectRatio: json['video_aspect_ratio'],
    );
  }

  Byte toDomain() {
    return Byte(
      id: id,
      title: title,
      url: url,
      cdnUrl: cdnUrl,
      thumbCdnUrl: thumbCdnUrl,
      user: user.toDomain(),
      category: category.toDomain(),
      totalViews: totalViews,
      totalLikes: totalLikes,
      totalComments: totalComments,
      totalShare: totalShare,
      totalWishlist: totalWishlist,
      duration: duration,
      byteAddedOn: DateTime.parse(byteAddedOn),
      byteUpdatedOn:
          byteUpdatedOn != null ? DateTime.parse(byteUpdatedOn!) : null,
      bunnyStreamVideoId: bunnyStreamVideoId,
      bytePlusVideoId: bytePlusVideoId,
      language: language,
      orientation: orientation,
      bunnyEncodingStatus: bunnyEncodingStatus,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
      videoHeight: videoHeight,
      videoWidth: videoWidth,
      location: location,
      isPrivate: isPrivate,
      isHideComment: isHideComment,
      description: description,
      archivedAt: archivedAt != null ? DateTime.parse(archivedAt!) : null,
      resolutions: resolutions.map((r) => r.toDomain()).toList(),
      isLiked: isLiked,
      isWished: isWished,
      isFollow: isFollow,
      metaDescription: metaDescription,
      metaKeywords: metaKeywords,
      videoAspectRatio: videoAspectRatio,
    );
  }
}

class UserModel {
  final int userId;
  final String fullname;
  final String username;
  final String? profilePicture;
  final String? profilePictureCdn;
  final String? designation;
  final bool isSubscriptionActive;
  final bool isFollow;

  UserModel({
    required this.userId,
    required this.fullname,
    required this.username,
    this.profilePicture,
    this.profilePictureCdn,
    this.designation,
    required this.isSubscriptionActive,
    required this.isFollow,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? 0,
      fullname: json['fullname'] ?? '',
      username: json['username'] ?? '',
      profilePicture: json['profile_picture'],
      profilePictureCdn: json['profile_picture_cdn'],
      designation: json['designation'],
      isSubscriptionActive: json['is_subscription_active'] ?? false,
      isFollow: json['is_follow'] ?? false,
    );
  }

  User toDomain() {
    return User(
      userId: userId,
      fullname: fullname,
      username: username,
      profilePicture: profilePicture,
      profilePictureCdn: profilePictureCdn,
      designation: designation,
      isSubscriptionActive: isSubscriptionActive,
      isFollow: isFollow,
    );
  }
}

class CategoryModel {
  final String title;

  CategoryModel({required this.title});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      title: json['title'] ?? '',
    );
  }

  Category toDomain() {
    return Category(title: title);
  }
}

class ResolutionModel {
  ResolutionModel();

  factory ResolutionModel.fromJson(Map<String, dynamic> json) {
    return ResolutionModel();
  }

  Resolution toDomain() {
    return Resolution();
  }
}
