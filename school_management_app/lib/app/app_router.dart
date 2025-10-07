import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/device_setup_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/device_email_verification_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/verification_code_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/data_loading_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/data_sync_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/role_selection_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/device-setup',
        name: 'device-setup',
        builder: (context, state) => const DeviceSetupPage(),
      ),
      GoRoute(
        path: '/device-verification',
        name: 'device-verification',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return DeviceEmailVerificationPage(
            universityId: args['universityId'],
            role: args['role'].toString(),
          );
        },
      ),
      GoRoute(
        path: '/verification-code',
        name: 'verification-code',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return VerificationCodePage(
            email: args['email'] as String,
            deviceInfo: args['deviceInfo'] as Map<String, String>,
            universityId: args['universityId'] as String,
            role: args['role'] as String,
          );
        },
      ),
      GoRoute(
        path: '/data-sync',
        name: 'data-sync',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return DataSyncPage(
            email: args['email'] as String,
            deviceInfo: Map<String, String>.from(args['deviceInfo'] as Map),
            universityId: args['universityId'] as String,
            role: args['role'] as String,
          );
        },
      ),
      GoRoute(
        path: '/role-selection',
        name: 'role-selection',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return RoleSelectionPage(
            universityName: args['universityName'],
            universityId: args['universityId'],
          );
        },
      ),
      GoRoute(
        path: '/data-loading',
        name: 'data-loading',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return DataLoadingPage(
            universityId: args['universityId'],
            role: args['role'].toString(),
          );
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // More routes will be added as we build features
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
