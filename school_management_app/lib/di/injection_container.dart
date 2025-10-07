import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/storage_service.dart';
import '../core/database/database_provider.dart';

final sl = GetIt.instance;

// Add this import at the top of the file

// Update the initializeDependencies function
Future<void> initializeDependencies() async {
  print('🔄 Initializing dependencies...');

  // 1. Initialize external dependencies
  print('📱 Initializing external dependencies...');
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());

  // 2. Initialize database
  print('💾 Initializing database...');
  await databaseProvider.init(); // This initializes the database

  // 3. Register core services
  print('🔧 Registering core services...');
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => StorageService(sl(), sl()));

  // 4. Register DAOs
  print('🗃️ Registering DAOs...');
  sl.registerLazySingleton(() => databaseProvider.userDao);

  print('✅ Dependencies initialized successfully');
}
