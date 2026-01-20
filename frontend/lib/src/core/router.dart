import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/common/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/provider/provider_dashboard.dart';
import '../features/provider/provider_registration_screen.dart';
import '../features/ai/ai_chat_screen.dart';
import '../features/home/user_profile_screen.dart';
import '../features/home/provider_details_screen.dart';
import '../features/chat/chat_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/provider-dashboard',
      builder: (context, state) => const ProviderDashboard(),
    ),
    GoRoute(
      path: '/register-provider',
      builder: (context, state) => const ProviderRegistrationScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AIChatScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/provider-details',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return ProviderDetailsScreen(providerData: data);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ChatScreen(
          bookingId: data['bookingId'] ?? 'demo_chat',
          otherUserName: data['otherUserName'] ?? 'User',
          otherUserId: data['otherUserId'] ?? 'unknown',
        );
      },
    ),
  ],
);
