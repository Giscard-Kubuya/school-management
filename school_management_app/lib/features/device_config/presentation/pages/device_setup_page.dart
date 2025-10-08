import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management_app/core/theme/app_colors.dart';
import 'package:school_management_app/core/usecases/usecase.dart';
import 'package:school_management_app/di/injection_container.dart';
import 'package:school_management_app/features/device_config/domain/entities/university.dart';
import 'package:school_management_app/features/device_config/domain/usecases/get_universities.dart';

class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({super.key});

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _searchController = TextEditingController();
  final GetUniversities _getUniversities = sl<GetUniversities>();
  List<University> _universities = [];
  List<University> _filteredUniversities = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedUniversityId;

  @override
  void initState() {
    super.initState();
    _fetchUniversities();
  }

  Future<void> _fetchUniversities() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getUniversities(NoParams());

    setState(() {
      _isLoading = false;
      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (universities) {
          _universities = universities;
          _filteredUniversities = List.from(_universities);
        },
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUniversities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUniversities = List.from(_universities);
      } else {
        _filteredUniversities = _universities
            .where(
              (uni) =>
                  uni.name.toLowerCase().contains(query.toLowerCase()) ||
                  (uni.country?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList();
      }
    });
  }

  void _handleContinue() {
    if (_selectedUniversityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your university')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Get selected university
    final selectedUni = _universities.firstWhere(
      (uni) => uni.id == _selectedUniversityId,
    );

    // Navigate to role selection page
    if (mounted) {
      setState(() => _isLoading = false);
      context.push(
        '/role-selection',
        extra: {
          'universityId': selectedUni.id,
          'universityName': selectedUni.name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Header
                  const Icon(Icons.school, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),

                  const Text(
                    'Device Setup',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Select your university to configure this device',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Search Field
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search University',
                      hintText: 'Enter university name or country',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterUniversities,
                  ),
                  const SizedBox(height: 16),

                  // Loading state
                  if (_isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  // Error state
                  else if (_errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load universities',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchUniversities,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Empty state
                  else if (_filteredUniversities.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No universities found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  // Universities List
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredUniversities.length,
                        itemBuilder: (context, index) {
                          final university = _filteredUniversities[index];
                          final isSelected =
                              _selectedUniversityId == university.id;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? AppColors.primary
                                    : AppColors.primaryContainer,
                                child: Icon(
                                  Icons.school,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                              title: Text(
                                university.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: university.country != null
                                  ? Text(university.country!)
                                  : null,
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedUniversityId = university.id;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Continue Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
