import '../../domain/entities/byte.dart';
import '../../domain/repositories/byte_repository.dart';
import '../models/byte_model.dart';
import '../../services/api_service/api_service.dart';

/// Repository implementation for handling Byte data operations.
///
/// This class implements the [ByteRepository] interface and is responsible
/// for retrieving Byte data from the API and transforming it into domain entities.
///
/// It uses [ApiService] to make network requests and converts the raw data
/// into [Byte] domain entities using [ByteModel] as an intermediary.
///
/// Example usage:
/// ```dart
/// final apiService = ApiService();
/// final byteRepository = ByteRepositoryImpl(apiService);
/// final bytes = await byteRepository.getBytes(1, 10);
/// ```
class ByteRepositoryImpl implements ByteRepository {
  final ApiService _apiService;

  ByteRepositoryImpl(this._apiService);

  @override
  Future<List<Byte>> getBytes(int page, int limit) async {
    try {
      final rawData = await _apiService.fetchBytes(page, limit);
      return rawData
          .map((json) => ByteModel.fromJson(json).toDomain())
          .toList();
    } catch (e) {
      rethrow; // Re-throw the exception so the BLoC can handle it
    }
  }
}
