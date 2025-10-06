import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

enum UserRole { student, teacher, manager }

class RoleSelectionPage extends StatefulWidget {
  final String universityName;
  final String universityId;

  const RoleSelectionPage({
    super.key,
    required this.universityName,
    required this.universityId,
  });

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  UserRole? _selectedRole;

  void _handleContinue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }
    
    // Navigate to verification page with university and role info
    context.push('/verification', extra: {
      'universityId': widget.universityId,
      'universityName': widget.universityName,
      'role': _selectedRole,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'What is your role at',
                  style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.universityName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _RoleCard(
                  role: UserRole.student,
                  title: 'Student',
                  description: 'Access courses, grades, and assignments.',
                  icon: Icons.school_outlined,
                  isSelected: _selectedRole == UserRole.student,
                  onTap: () => setState(() => _selectedRole = UserRole.student),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  role: UserRole.teacher,
                  title: 'Teacher',
                  description: 'Manage courses, grade assignments, and post announcements.',
                  icon: Icons.person_outline,
                  isSelected: _selectedRole == UserRole.teacher,
                  onTap: () => setState(() => _selectedRole = UserRole.teacher),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  role: UserRole.manager,
                  title: 'Manager',
                  description: 'Oversee university operations and system settings.',
                  icon: Icons.admin_panel_settings_outlined,
                  isSelected: _selectedRole == UserRole.manager,
                  onTap: () => setState(() => _selectedRole = UserRole.manager),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
        ),
      ),
    );
  }
}
