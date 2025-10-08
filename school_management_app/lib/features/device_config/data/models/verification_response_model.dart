// Simple model to handle verification responses
class VerificationResponseModel {
  final String status;
  final String message;
  final Map<String, dynamic> data;

  VerificationResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VerificationResponseModel.fromJson(Map<String, dynamic> json) {
    print('Verification Response: $json');
    return VerificationResponseModel(
      status: json['status'] as String? ?? 'error',
      message: json['message'] as String? ?? 'No message',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  // Helper getter for device ID
  String? get deviceId => data['device_id'] as String?;

  @override
  String toString() {
    return 'VerificationResponseModel(status: $status, message: $message, data: $data)';
  }
}
