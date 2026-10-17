import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simplycardtracker/core/router/app_router.dart';
import 'package:simplycardtracker/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      title: 'Simply Card Tracker',
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: child,
          ),
        ),
      ),
    );
  }
}
