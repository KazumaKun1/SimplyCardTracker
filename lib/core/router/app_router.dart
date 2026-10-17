import 'package:go_router/go_router.dart';

import 'package:simplycardtracker/core/widgets/app_shell.dart';
import 'package:simplycardtracker/features/card/credit/presentation/credit_screen.dart';
import 'package:simplycardtracker/features/card/debit/presentation/debit_screen.dart';
import 'package:simplycardtracker/features/settings/presentation/settings_screen.dart';

final router = GoRouter(
  initialLocation: '/debit',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/debit',
              builder: (context, state) => const DebitScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/credit',
              builder: (context, state) => const CreditScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
