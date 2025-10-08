import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_management_app/core/constants/app_constants.dart';
import 'package:school_management_app/core/constants/storage_keys.dart';
import 'package:school_management_app/core/utils/logger.dart';

class DataSyncPage extends StatefulWidget {
  final String email;
  final Map<String, String> deviceInfo;
  final String universityId;
  final String role;

  const DataSyncPage({
    Key? key,
    required this.email,
    required this.deviceInfo,
    required this.universityId,
    required this.role,
  }) : super(key: key);

  @override
  _DataSyncPageState createState() => _DataSyncPageState();
}

class _DataSyncPageState extends State<DataSyncPage> {
  double _progress = 0.0;
  bool _isSyncing = true;
  String _status = 'Preparing to sync...';

  @override
  void initState() {
    super.initState();
    _startSync();
  }

  Future<void> _startSync() async {
    try {
      setState(() {
        _isSyncing = true;
        _status = 'Preparing data sync...';
        _progress = 0.0;
      });

      // Define data types to sync with their display names and weights
      final dataTypes = [
        {'name': 'universities', 'weight': 0.1},
        {'name': 'students', 'weight': 0.6},
        {'name': 'courses', 'weight': 0.3},
      ];

      double currentProgress = 0.0;
      final Map<String, dynamic> syncData = {};

      // Process each data type
      for (var dataType in dataTypes) {
        final String typeName = dataType['name'] as String;
        final double weight = dataType['weight'] as double;
        
        setState(() {
          _status = 'Loading $typeName...';
        });

        try {
          // Simulate API call to fetch data
          await Future.delayed(const Duration(seconds: 1));
          
          // In a real app, you would fetch data from your API here
          // final response = await apiClient.get('/api/$typeName');
          // syncData[typeName] = response.data;
          
          // For demonstration, using mock data
          switch (typeName) {
            case 'universities':
              syncData[typeName] = [
                {'id': 1, 'name': 'University of Technology'},
                // Add more universities as needed
              ];
              break;
            case 'students':
              syncData[typeName] = List.generate(
                50, 
                (index) => {
                  'id': index + 1,
                  'name': 'Student ${index + 1}',
                  'university_id': 1,
                },
              );
              break;
            case 'courses':
              syncData[typeName] = [
                {'id': 1, 'name': 'Computer Science', 'university_id': 1},
                {'id': 2, 'name': 'Mathematics', 'university_id': 1},
                {'id': 3, 'name': 'Physics', 'university_id': 1},
                // Add more courses as needed
              ];
              break;
          }
          
          currentProgress += weight;
          setState(() {
            _progress = currentProgress;
            _status = 'Loaded ${syncData[typeName].length} $typeName';
          });
          
          // Small delay to show progress
          await Future.delayed(const Duration(milliseconds: 300));
          
        } catch (e) {
          'Error loading $typeName: $e'.logError();
          // Continue with next data type even if one fails
          continue;
        }
      }

      // Save the loaded data to local storage
      await _saveDeviceInfo();
      await _saveSyncData(syncData);

      setState(() {
        _status = 'Sync completed successfully!';
        _progress = 1.0;
        _isSyncing = false;
      });

      // Navigate to auth screen after a short delay
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        final router = GoRouter.of(context);
        if (mounted) {
          // This will clear all routes and go to login
          router.go('/login');
        }
      }
    } catch (e) {
      'Sync failed: $e'.logError();
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _status = 'Sync failed. Please check your connection and try again.';
        });
      }
    }
  }

  Future<void> _saveSyncData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save each data type to shared preferences
      await Future.wait([
        // Save universities
        if (data['universities'] != null)
          prefs.setString('universities', jsonEncode(data['universities'])),
          
        // Save students
        if (data['students'] != null)
          prefs.setString('students', jsonEncode(data['students'])),
          
        // Save courses
        if (data['courses'] != null)
          prefs.setString('courses', jsonEncode(data['courses'])),
      ]);
      
      'Sync data saved successfully'.logInfo();
    } catch (e) {
      'Error saving sync data: $e'.logError();
      rethrow;
    }
  }

  Future<void> _saveDeviceInfo() async {
    try {
      // Save device info to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(StorageKeys.selectedUniversityId, widget.universityId),
        prefs.setString(StorageKeys.userRole, widget.role),
        prefs.setString(StorageKeys.userEmail, widget.email),
        prefs.setBool(StorageKeys.isDeviceConfigured, true),
      ]);
      
      // Add a small delay to show the progress
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      'Failed to save device info: $e'.logError();
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_download,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                _isSyncing ? 'Setting up your account...' : 'All set!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isSyncing ? Theme.of(context).primaryColor : Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('${(_progress * 100).toInt()}%'),
              if (!_isSyncing) ...[
                const SizedBox(height: 32),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your device is ready to use!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
              if (_status.contains('failed')) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _startSync,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
