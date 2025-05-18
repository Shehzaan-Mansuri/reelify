import '../entities/byte.dart';

/// Repository interface for managing Byte entities.
///
/// This abstract class defines the contract for accessing and manipulating Byte data.
/// Implementations of this repository are responsible for handling data retrieval
/// from various sources (e.g., remote API, local database).
///
/// The repository follows the Repository pattern, abstracting the data layer
/// from the business logic and providing a clean API for the application's use cases.
abstract class ByteRepository {
  Future<List<Byte>> getBytes(int page, int limit);
}
