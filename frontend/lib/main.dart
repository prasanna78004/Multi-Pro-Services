import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'src/core/router.dart';
import 'src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MultiProServicesApp());
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

class MultiProServicesApp extends StatelessWidget {
  const MultiProServicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MultiProServices',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Icon(Icons.error_outline, color: Colors.red, size: 48),
                 const SizedBox(height: 16),
                 const Text('Failed to initialize app', style: TextStyle(fontSize: 20)),
                 const SizedBox(height: 8),
                 Text(error, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
