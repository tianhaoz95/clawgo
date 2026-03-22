import 'package:cyberclaw/src/presentation/screens/chat_console_screen.dart';
import 'package:cyberclaw/src/presentation/screens/forgot_password_screen.dart';
import 'package:cyberclaw/src/presentation/screens/sign_in_screen.dart';
import 'package:cyberclaw/src/presentation/screens/sign_up_screen.dart';
import 'package:cyberclaw/src/presentation/screens/user_profile_settings_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatConsoleScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const UserProfileSettingsScreen(),
    ),
  ],
);
