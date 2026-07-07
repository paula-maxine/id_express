import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/printer/printer.dart';
import 'firebase_options.dart';
import 'app/id_express.dart';

void main() {
  // Run the app inside a guarded zone so that any uncaught asynchronous error
  // (outside the Flutter framework) is logged to the debug console.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Log all errors caught by the Flutter framework (build/layout/paint,
      // gesture callbacks, etc.) to the debug console.
      FlutterError.onError = (details) {
        // A hot restart on Flutter web disposes the previous EngineFlutterView
        // while a frame is still scheduled against it, producing a transient
        // "Trying to render a disposed EngineFlutterView" assertion. It is a
        // harmless shutdown-race artifact, not an app bug — swallow it so it
        // doesn't spam the console or mask real errors.
        if (_isDisposedViewError(details.exception)) return;

        FlutterError.presentError(details);
        Printer.error(
          details.exceptionAsString(),
          tag: 'FlutterError',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      // Log errors that reach the platform dispatcher (uncaught async errors
      // that bubble up outside the Flutter framework).
      PlatformDispatcher.instance.onError = (error, stack) {
        if (_isDisposedViewError(error)) return true;
        Printer.error(
          'Uncaught platform error',
          tag: 'PlatformDispatcher',
          error: error,
          stackTrace: stack,
        );
        return true;
      };

      // Initialize Firebase
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Enable offline persistence so streams emit cached data immediately
        // on cold start, then reconcile with the server in the background.
        // This is the biggest win for perceived load time — the UI no longer
        // blocks on a network round-trip before the first snapshot arrives.
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      } catch (e, s) {
        Printer.error(
          'Firebase initialization failed',
          tag: 'Startup',
          error: e,
          stackTrace: s,
        );
        rethrow;
      }

      runApp(const ProviderScope(child: IdExpress()));
    },
    (error, stack) {
      if (_isDisposedViewError(error)) return;
      Printer.error(
        'Uncaught zone error',
        tag: 'Zone',
        error: error,
        stackTrace: stack,
      );
    },
  );
}

/// Detects the transient "Trying to render a disposed EngineFlutterView"
/// assertion that Flutter web throws when a frame is drawn against a view that
/// was disposed by a hot restart / page teardown. It is not an app-level error.
bool _isDisposedViewError(Object error) {
  final message = error.toString();
  return message.contains('disposed EngineFlutterView') ||
      (error is AssertionError && message.contains('isDisposed'));
}
