import '../entities/byte.dart';
import '../repositories/byte_repository.dart';

/// The `FetchBytesUseCase` is responsible for retrieving a paginated list of bytes from the repository.
///
/// This class follows the Clean Architecture's use case pattern, acting as an intermediary
/// between the presentation layer and the repository layer.
///
/// ## Parameters:
/// - `_byteRepository`: An instance of [ByteRepository] that provides access to the bytes data source.
///
/// ## Usage:
/// ```
/// final useCase = FetchBytesUseCase(byteRepository);
/// final bytes = await useCase.execute(1, 20); // Fetch first page with 20 items
/// ```
///
/// ## Implementation Details:
/// The [execute] method delegates the actual data fetching to the repository,
/// allowing for separation of concerns and easier testing.

class FetchBytesUseCase {
  final ByteRepository _byteRepository;

  FetchBytesUseCase(this._byteRepository);

  Future<List<Byte>> execute(int page, int limit) async {
    return _byteRepository.getBytes(page, limit);
  }
}
