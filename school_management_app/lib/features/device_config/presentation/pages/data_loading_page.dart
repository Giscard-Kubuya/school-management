import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class DataLoadingPage extends StatefulWidget {
  final String universityId;
  final String role;

  const DataLoadingPage({
    super.key,
    required this.universityId,
    required this.role,
  });

  @override
  State<DataLoadingPage> createState() => _DataLoadingPageState();
}

class _DataLoadingPageState extends State<DataLoadingPage> {
  String _status = 'Initializing...';
  double _progress = 0.0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  Future<void> _startLoading() async {
    try {
      setState(() {
        _status = 'Connecting to server...';
        _progress = 0.1;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _status = 'Fetching university data...';
        _progress = 0.3;
      });

      // Simulate fetching university data
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _status = 'Processing data...';
        _progress = 0.6;
      });

      // Simulate data processing
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _status = 'Saving to local storage...';
        _progress = 0.8;
      });

      // Save device configuration
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.universityIdKey, widget.universityId);
      await prefs.setString(AppConstants.userRoleKey, widget.role.toString());
      await prefs.setBool(AppConstants.isDeviceConfiguredKey, true);

      setState(() {
        _status = 'Finalizing setup...';
        _progress = 1.0;
      });

      // Navigate to login page after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        // Clear all routes and go to login
        context.go('/login');
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 32),
                Text(
                  'Setting Up Your Account',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  _status,
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _hasError ? Colors.red : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_hasError) ...[
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _startLoading,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
