import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:keyless_kawai/views/homepage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // We have to call this first because we're doing async native OS stuff
  // (like window manipulation) before Flutter actually spins up the UI.
  WidgetsFlutterBinding.ensureInitialized();

  // Crucial gotcha: Always check !kIsWeb BEFORE touching Platform.isX.
  // If Flutter tries to read dart:io properties in a web browser, the app instantly crashes.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {

    // Hook into the native desktop window manager
    await windowManager.ensureInitialized();

    // We're building this to feel like a strict hardware utility/dashboard,
    // so we're locking the aspect ratio down hard.
    WindowOptions windowOptions = const WindowOptions(
      size: Size(600, 600),         // The starting footprint
      minimumSize: Size(600, 600),  // Don't let users squish it and break the layout
      maximumSize: Size(600, 600),  // Don't let them stretch it into empty space
      center: true,                 // Pop up dead center on the monitor
      title: "Keyless Kawaii",
    );

    // Wait until the first frame is painted before showing the window.
    // This prevents that ugly white flash you normally see when desktop apps boot up.
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();

      // Double-tapping the window constraints at the OS level.
      // This actually greys out the native maximize button in the Windows/Mac title bar.
      await windowManager.setResizable(false);
      await windowManager.setMaximizable(false);
    });
  }

  // Boot up the actual app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner (it looks bad on desktop windows)
      title: "Keyless Kawaii",
      home: Homepage(),
    );
  }
}