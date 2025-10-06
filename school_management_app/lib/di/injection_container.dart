import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/storage_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());
  
  // Core
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => StorageService(sl(), sl()));
  
  // Features will be registered here as we build them
}
