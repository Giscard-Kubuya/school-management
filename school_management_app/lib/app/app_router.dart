import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/device_setup_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/device_email_verification_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/verification_code_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/data_loading_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/data_sync_page.dart';
import 'package:school_management_app/features/device_config/presentation/pages/role_selection_page.dart';
import 'package:school_management_app/features/device_config/domain/repositories/device_config_repository.dart';
import 'package:school_management_app/features/device_config/data/repositories/device_config_repository_impl.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_config_remote_data_source.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_local_data_source_impl.dart';
import 'package:school_management_app/core/network/api_client.dart';
import 'package:school_management_app/core/network/network_info_impl.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_info_service.dart';
import 'package:school_management_app/core/database/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

          // Create required dependencies
          final apiClient = ApiClient();
          final connectivity = Connectivity();
          final networkInfo = NetworkInfoImpl(connectivity);
          final deviceInfoService = DeviceInfoService();
          final databaseHelper = DatabaseHelper();
          final localDataSource = DeviceLocalDataSourceImpl(databaseHelper);

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<DeviceConfigRepository>(
                create: (context) => DeviceConfigRepositoryImpl(
                  remoteDataSource: DeviceConfigRemoteDataSourceImpl(
                    apiClient: apiClient,
                  ),
                  localDataSource: localDataSource,
                  networkInfo: networkInfo,
                  deviceInfoService: deviceInfoService,
                ),
              ),
            ],
            child: DeviceEmailVerificationPage(
              universityId: args['universityId'],
              role: args['role'].toString(),
            ),
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
            deviceInfo: Map<String, dynamic>.from(args['deviceInfo'] as Map).map((key, value) => 
              MapEntry(key, value.toString())),
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
