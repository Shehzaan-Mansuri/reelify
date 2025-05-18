/*
 * main.dart
 * 
 * Application entry point for Reelify - a short-form video viewing application.
 * 
 * This file:
 * 1. Initializes the Flutter framework
 * 2. Sets up dependency injection
 * 3. Configures the application theme
 * 4. Creates the initial widget tree with proper state management
 * 
 * The app follows a clean architecture approach with BLoC pattern for state management,
 * allowing for separation of concerns and testable, maintainable code.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/injection_container.dart' as di;
import 'presentation/bloc/byte_bloc/byte_bloc.dart';
import 'presentation/bloc/byte_bloc/byte_event.dart';
import 'presentation/screens/reels_page.dart';

/// Application entry point
///
/// This function performs necessary initialization before starting the app:
/// 1. Ensures Flutter bindings are initialized (required for plugins)
/// 2. Sets up dependency injection
/// 3. Launches the root widget (MyApp)
void main() async {
  // Initialize Flutter binding - required before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection container
  await di.init();

  // Start the application with the root widget
  runApp(const MyApp());
}

/// Root application widget
///
/// This widget configures:
/// - The application theme (dark theme with blue accents)
/// - Global state management using BLoC providers
/// - Initial navigation to the ReelsPage
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reelify',
      // App-wide dark theme with blue accent colors
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
      // Providing ByteBloc at the app level allows state sharing across screens
      home: BlocProvider(
        create: (context) => di.sl<ByteBloc>()..add(FetchInitialBytesEvent()),
        child: const ReelsPage(),
      ),
    );
  }
}
