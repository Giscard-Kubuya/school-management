import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({super.key});

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _searchController = TextEditingController();
  String? _selectedUniversity;
  bool _isLoading = false;

  // Mock universities data
  final List<Map<String, String>> _universities = [
    {'id': '1', 'name': 'Harvard University', 'country': 'United States'},
    {'id': '2', 'name': 'Oxford University', 'country': 'United Kingdom'},
    {'id': '3', 'name': 'MIT', 'country': 'United States'},
    {'id': '4', 'name': 'Stanford University', 'country': 'United States'},
    {'id': '5', 'name': 'Cambridge University', 'country': 'United Kingdom'},
  ];

  List<Map<String, String>> _filteredUniversities = [];

  @override
  void initState() {
    super.initState();
    _filteredUniversities = _universities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUniversities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUniversities = _universities;
      } else {
        _filteredUniversities = _universities
            .where(
              (uni) =>
                  uni['name']!.toLowerCase().contains(query.toLowerCase()) ||
                  uni['country']!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _handleContinue() {
    if (_selectedUniversity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your university')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate device registration request
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);

        // Get selected university
        final selectedUni = _universities.firstWhere(
          (uni) => uni['id'] == _selectedUniversity,
        );

        // Navigate to role selection page with university info
        context.push(
          '/role-selection',
          extra: {
            'universityName': selectedUni['name'],
            'universityId': selectedUni['id'],
          },
        );
      }
    });
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

                  // Universities List
                  Expanded(
                    child: _filteredUniversities.isEmpty
                        ? const Center(
                            child: Text(
                              'No universities found',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredUniversities.length,
                            itemBuilder: (context, index) {
                              final university = _filteredUniversities[index];
                              final isSelected =
                                  _selectedUniversity == university['id'];

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
                                    university['name']!,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: Text(university['country']!),
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: AppColors.success,
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _selectedUniversity = university['id'];
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
