import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_app/core/network/api_client.dart';
import 'package:school_management_app/features/device_config/data/models/verification_response_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class VerificationCodePage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> deviceInfo;
  final String universityId;
  final String role;

  const VerificationCodePage({
    Key? key,
    required this.email,
    required this.deviceInfo,
    required this.universityId,
    required this.role,
  }) : super(key: key);

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isVerifying = false;
  bool _showResend = false;
  bool _isVerified = false;
  int _resendCountdown = 30;
  Timer? _resendTimer;
  String? _verificationCode;
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-fill with test code in debug mode
    if (kDebugMode) {
      _verificationCode = '123456'; // Default test code
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _showResend = false;
      _resendCountdown = 30;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _showResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _verifyCode() async {
    if (_isVerifying) return;

    final enteredCode = _codeControllers.map((c) => c.text).join();

    // Validate code length
    if (enteredCode.length != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the complete 6-digit code'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final apiClient = ApiClient();
      final response = await apiClient.post(
        '/devices/verify',
        data: {
          'email': widget.email,
          'device_uuid': widget.deviceInfo['uuid'],
          'verification_code': enteredCode,
        },
      );

      if (!mounted) return;

      final verificationResponse = VerificationResponseModel.fromJson(response);
      
      if (verificationResponse.status == 'success') {
        setState(() => _isVerified = true);
        
        // Navigate to data sync after a delay
        if (mounted) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go(
                '/data-sync',
                extra: {
                  'email': widget.email,
                  'deviceInfo': widget.deviceInfo,
                  'universityId': widget.universityId,
                  'role': widget.role,
                },
              );
            }
          });
        }
      } else {
        throw Exception(verificationResponse.message);
      }
    } catch (e) {
      if (mounted) {
        // Clear all input fields on error
        for (var controller in _codeControllers) {
          controller.clear();
        }
        if (_focusNodes.isNotEmpty) {
          FocusScope.of(context).requestFocus(_focusNodes[0]);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resendCode() async {
    try {
      setState(() => _isVerifying = true);

      final apiClient = ApiClient();
      final response = await apiClient.post(
        '/devices/send-verification-code',
        data: {
          'email': widget.email,
          'device': {
            ...widget.deviceInfo,
            'verification_code': _verificationCode,
          },
        },
      );

      if (!mounted) return;

      final verificationResponse = VerificationResponseModel.fromJson(response);
      
      if (verificationResponse.status == 'success') {
        _deviceId = verificationResponse.deviceId;
        if (kDebugMode) {
          print('Verification code sent. Device ID: $_deviceId');
        }
        _startResendTimer();
        
        if (mounted) {
          // Clear any existing code
          for (var controller in _codeControllers) {
            controller.clear();
          }
          if (_focusNodes.isNotEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[0]);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(verificationResponse.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(verificationResponse.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to resend code: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _verifyCode();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security, size: 40, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            Text(
              'Enter Verification Code',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'We sent a 6-digit code to',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (_isVerified)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 60,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Successfully Authorized',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 40,
                        height: 4,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 36,
                        child: TextField(
                          controller: _codeControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(fontSize: 20),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          onChanged: (value) => _onCodeChanged(value, index),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            if (!_isVerified)
              Column(
                children: [
                  const SizedBox(height: 40),
                  _showResend
                      ? Center(
                          child: TextButton(
                            onPressed: _resendCode,
                            child: const Text("Didn't receive a code? Resend"),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Resend code in $_resendCountdown seconds',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 24),
                ],
              )
            else
              const SizedBox(height: 24),
            if (_isVerifying) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
