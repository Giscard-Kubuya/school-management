import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/storage_service.dart';
import '../core/database/database_provider.dart';
import '../core/database/database_helper.dart';
import '../features/device_config/data/datasources/device_info_service.dart';
import '../features/device_config/data/datasources/device_local_data_source.dart';
import '../features/device_config/data/datasources/device_local_data_source_impl.dart';
import '../features/device_config/data/datasources/device_config_remote_data_source.dart';
import '../features/device_config/data/repositories/device_config_repository_impl.dart';
import '../features/device_config/domain/repositories/device_config_repository.dart';
import '../features/device_config/domain/usecases/get_universities.dart';

final sl = GetIt.instance;

// Add this import at the top of the file

// Update the initializeDependencies function
Future<void> initializeDependencies() async {
  print('🔄 Initializing dependencies...');

  // 1. Initialize basic services needed for device check
  print('📱 Initializing basic services...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());

  // 2. Get device info
  final deviceInfo = await sl<DeviceInfoService>().getDeviceInfo();
  final deviceId = deviceInfo['deviceId'] ?? 'unknown';
  print('📱 Device ID: $deviceId');

  // 3. Initialize database and check registration status
  print('💾 Initializing database...');
  await databaseProvider.init();

  final databaseHelper = DatabaseHelper();
  final deviceLocalDataSource = DeviceLocalDataSourceImpl(databaseHelper);
  sl.registerLazySingleton<DeviceLocalDataSource>(() => deviceLocalDataSource);

  // 4. Check if device is registered
  print('🔍 Checking device registration status...');
  final isRegistered = await deviceLocalDataSource.isDeviceRegistered(deviceId);
  print('📱 Device registration status - Registered: $isRegistered');

  // 5. Register core services (lazy loaded when needed)
  print('🔧 Registering core services...');

  // Register core services with lazy loading
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Initialize storage service
  sl.registerLazySingleton<StorageService>(() => StorageService(sl(), sl()));

  // 6. Register DAOs
  print('🗃️ Registering DAOs...');
  sl.registerLazySingleton(() => databaseProvider.userDao);

  // 7. Register remote data source (lazy loaded when first used)
  sl.registerLazySingleton<DeviceConfigRemoteDataSource>(
    () => DeviceConfigRemoteDataSourceImpl(apiClient: sl()),
  );

  // 8. Register repository (lazy loaded when first used)
  sl.registerLazySingleton<DeviceConfigRepository>(
    () => DeviceConfigRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl<DeviceLocalDataSource>(),
      networkInfo: sl(),
      deviceInfoService: sl<DeviceInfoService>(),
    ),
  );

  // 9. Register use cases
  sl.registerLazySingleton(() => GetUniversities(sl()));

  if (!isRegistered) {
    print('⚠️  Device not registered. Will fetch universities when needed.');
  } else {
    print('✅ Device is already registered. Skipping service initialization.');
  }

  print('✅ Dependencies initialized successfully');
}
