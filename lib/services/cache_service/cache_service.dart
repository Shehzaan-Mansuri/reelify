import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/byte.dart';
import 'dart:convert';

/// A service that handles caching and retrieving of [Byte] objects using SharedPreferences.
///
/// This service provides functionality to:
/// * Cache a list of [Byte] objects by serializing them to JSON and storing in SharedPreferences
/// * Retrieve cached [Byte] objects by deserializing JSON data from SharedPreferences
///
/// The service uses a single key [_cacheKey] to store all cached bytes as a list of JSON strings.
/// When retrieving bytes, a simplified version of the [Byte] object is created with only essential
/// fields populated, as the complete object might not be necessary for cached data.
///
/// Usage:
/// ```dart
/// final cacheService = CacheService();
///
/// // Cache bytes
/// await cacheService.cacheBytes(bytesList);
///
/// // Retrieve cached bytes
/// final cachedBytes = await cacheService.getCachedBytes();
/// ```
class CacheService {
  static const String _cacheKey = 'videoCache';

  Future<void> cacheBytes(List<Byte> bytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> byteJsonList =
        bytes.map((byte) => jsonEncode(_byteToJson(byte))).toList();
    await prefs.setStringList(_cacheKey, byteJsonList);
  }

  Future<List<Byte>> getCachedBytes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? byteJsonList = prefs.getStringList(_cacheKey);
    if (byteJsonList != null) {
      return byteJsonList
          .map((jsonString) => _byteFromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  // Helper function to convert Byte entity to JSON
  Map<String, dynamic> _byteToJson(Byte byte) {
    return {
      'id': byte.id,
      'cdnUrl': byte.cdnUrl,
    };
  }

  // Helper function to convert JSON to Byte entity
  Byte _byteFromJson(Map<String, dynamic> json) {
    return Byte(
      id: json['id'],
      title: '', // We might not cache the full title for simplicity
      url: '',
      cdnUrl: json['cdnUrl'],
      thumbCdnUrl: '',
      user: User(
          userId: 0,
          fullname: '',
          username: '',
          isSubscriptionActive: false,
          isFollow: false),
      category: Category(title: ''),
      totalViews: 0,
      totalLikes: 0,
      totalComments: 0,
      totalShare: 0,
      totalWishlist: 0,
      duration: 0,
      byteAddedOn: DateTime.now(),
      language: '',
      orientation: '',
      bunnyEncodingStatus: 0,
      videoHeight: 0,
      videoWidth: 0,
      isPrivate: 0,
      isHideComment: 0,
      resolutions: [],
      isLiked: false,
      isWished: false,
      isFollow: false,
      bunnyStreamVideoId: null,
      bytePlusVideoId: null,
      byteUpdatedOn: null,
      deletedAt: null,
      location: null,
      description: null,
      archivedAt: null,
      metaDescription: null,
      metaKeywords: null,
      videoAspectRatio: null,
    );
  }
}
