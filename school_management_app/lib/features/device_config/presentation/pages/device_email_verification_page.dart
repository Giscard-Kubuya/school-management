import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management_app/core/utils/logger.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_info_service.dart';
import 'package:school_management_app/features/device_config/domain/entities/device_info.dart';
import 'package:school_management_app/features/device_config/domain/repositories/device_config_repository.dart';

class DeviceEmailVerificationPage extends StatefulWidget {
  final String universityId;
  final String role;

  const DeviceEmailVerificationPage({
    Key? key,
    required this.universityId,
    required this.role,
  }) : super(key: key);

  @override
  _DeviceEmailVerificationPageState createState() =>
      _DeviceEmailVerificationPageState();
}

class _DeviceEmailVerificationPageState
    extends State<DeviceEmailVerificationPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String> _deviceInfo = {};
  final DeviceInfoService _deviceInfoService = DeviceInfoService();

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final info = await _deviceInfoService.getDeviceInfo();
      setState(() {
        _deviceInfo.addAll(info);
      });
    } catch (e) {
      'Failed to load device info: $e'.logError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load device information')),
      );
    }
  }

  // Validates device info and returns null if valid, error message otherwise
  String? _validateDeviceInfo(Map<String, dynamic> deviceInfo) {
    final requiredFields = {
      'deviceId': 'Device ID',
      'osName': 'Operating System',
      'osVersion': 'OS Version',
      'appVersion': 'App Version',
    };

    // Check for missing required fields
    for (final entry in requiredFields.entries) {
      final value = deviceInfo[entry.key];
      if (value == null || value.toString().trim().isEmpty) {
        return '${entry.value} is required';
      }
    }

    // Validate device ID format (UUID)
    final deviceId = deviceInfo['deviceId']?.toString() ?? '';
    if (deviceId.isEmpty) {
      return 'Device ID is required';
    }

    return null;
  }

  Future<void> _sendVerificationCode() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();

      // Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw Exception('Please enter a valid email address');
      }

      // Validate device info
      final validationError = _validateDeviceInfo(_deviceInfo);
      if (validationError != null) {
        throw Exception(validationError);
      }

      // Create DeviceInfo entity from the raw device info with proper fallbacks
      final deviceInfo = DeviceInfo(
        deviceId: _deviceInfo['deviceId']?.toString().trim() ?? '',
        deviceName:
            _deviceInfo['deviceName']?.toString().trim() ?? 'Unknown Device',
        osName: _deviceInfo['osName']?.toString().trim() ?? 'Unknown OS',
        osVersion: _deviceInfo['osVersion']?.toString().trim() ?? '1.0.0',
        appVersion: _deviceInfo['appVersion']?.toString().trim() ?? '1.0.0',
        model: _deviceInfo['model']?.toString().trim(),
        manufacturer: _deviceInfo['manufacturer']?.toString().trim(),
        appBuildNumber:
            _deviceInfo['appVersion']?.toString().split('+').lastOrNull ?? '1',
        appIdentifier:
            _deviceInfo['app_identifier']?.toString() ??
            'school_management_app',
        universityId: widget.universityId,
      );

      // Debug print to verify the device info
      'Device Info: ${deviceInfo.toJson()}'.logInfo();

      // Log the device info being sent
      'Sending device info: ${deviceInfo.toJson()}'.logInfo();

      // Get repository from context
      final repository = RepositoryProvider.of<DeviceConfigRepository>(context);

      // Call repository to send verification code
      final result = await repository.sendVerificationCode(
        email: email,
        deviceInfo: deviceInfo,
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (response) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification code sent successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to verification code page
          if (mounted) {
            // Ensure we have the device UUID
            final deviceUuid = _deviceInfo['deviceId'] ?? response['device_id'];
            if (deviceUuid == null) {
              throw Exception('Device UUID is required');
            }
            
            // Navigate to verification code page with all required parameters
            context.pushNamed(
              'verification-code',
              extra: {
                'email': email,
                'deviceInfo': {
                  ..._deviceInfo,
                  'uuid': deviceUuid, // Make sure this is included
                  'verificationCode': response['verification_code'],
                },
                'universityId': widget.universityId,
                'role': widget.role,
                'verificationCode': response['verification_code'],
                'deviceId': response['device_id'],
              },
            );
          }
        },
      );
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification code: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set default university email for testing
    if (_emailController.text.isEmpty) {
      _emailController.text = 'test@university.edu';
    }

    // Filter and select only relevant device info
    final relevantDeviceInfo = {
      'Device': _deviceInfo['device'] ?? 'Unknown Device',
      'OS': _deviceInfo['os'] ?? 'Unknown OS',
      'Model': _deviceInfo['model'] ?? 'Unknown Model',
    };

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.phone_android,
                              size: 60,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Verify Your Device',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Please enter your university email to verify this device',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Device Information Card
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Device Information',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...relevantDeviceInfo.entries
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    '${e.key}:',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: Text(e.value)),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'University Email',
                                hintText: 'Enter your university email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                if (!value.endsWith('.edu') &&
                                    !value.contains('@university.')) {
                                  return 'Please use your university email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _sendVerificationCode,
                                child: const Text('Send Verification Code'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
