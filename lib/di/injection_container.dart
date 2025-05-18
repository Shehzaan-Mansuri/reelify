/*
 * injection_container.dart
 * 
 * This file sets up the dependency injection container for the application using GetIt.
 * Dependency injection helps to decouple the creation of objects from their usage,
 * making the codebase more maintainable, testable, and scalable.
 * 
 * The container registers services, repositories, use cases, and BLoCs following
 * clean architecture principles:
 * - Services: External interfaces like API and cache services
 * - Repositories: Data management components that coordinate multiple data sources
 * - Use Cases: Business logic components that encapsulate a specific app feature
 * - BLoCs: State management components that connect the UI to the domain layer
 */

import 'package:get_it/get_it.dart';
import '../data/repositories/byte_repository_impl.dart';
import '../domain/repositories/byte_repository.dart';
import '../domain/use_cases/fetch_bytes_use_case.dart';
import '../presentation/bloc/byte_bloc/byte_bloc.dart';
import '../services/api_service/api_service.dart';

// Global service locator instance
final sl = GetIt.instance;

/// Initializes all dependencies in the application
/// This function must be called before the app starts running (typically in main.dart)
Future<void> init() async {
  // Register services - lowest level components that interact with external systems
  sl.registerLazySingleton(() => ApiService());

  // Register repositories - components that coordinate data from different sources
  // We register with an interface to follow the dependency inversion principle
  sl.registerLazySingleton<ByteRepository>(() => ByteRepositoryImpl(sl()));

  // Register use cases - business logic components that represent app features
  sl.registerLazySingleton(() => FetchBytesUseCase(sl()));

  // Register BLoCs - state management components that connect UI to domain layer
  // Using factory ensures a new instance each time, suitable for scoped features
  sl.registerFactory(() => ByteBloc(sl()));
}
