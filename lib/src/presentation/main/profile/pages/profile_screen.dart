import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';
import 'package:mouvema/src/data/models/user.dart';
import 'package:mouvema/src/data/repository/repository_impl.dart';
import 'package:mouvema/src/presentation/main/profile/cubit/profile_cubit.dart';
import 'package:mouvema/src/presentation/main/profile/cubit/profile_state.dart';
import '../../../../config/routes/routes.dart';
import '../../../../injector.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(instance<RepositoryImpl>()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state.status == Status.failed) {
                  // Only show error dialog if it's not related to logout
                  AwesomeDialog(
                    btnOkColor: Colors.teal,
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    title: StringManager.error,
                    desc: state.errorMessage ?? 'An error occurred',
                  ).show();
                } else if (state.status == Status.logOut) {
                  // Show quick success message and navigate after delay

                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.login,
                      (route) => false,
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == Status.success) {
                  return _getProfile(
                      user: state.data!,
                      context: context,
                      onLogoutPressed: () {
                        BlocProvider.of<ProfileCubit>(context).logOut();
                      });
                } else if (state.status == Status.logOut) {
                  // Firebase auth will handle navigation, just show loading briefly
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                      child:
                          Text(state.errorMessage ?? 'Something went wrong'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getProfile({
    required MyUser user,
    required BuildContext context,
    required VoidCallback onLogoutPressed,
  }) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(height: 16),
                Text(
                  user.username,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Settings section
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: StringManager.editProfile,
                  onTap: () => Navigator.pushNamed(context, Routes.fillProfil),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.car_repair_outlined,
                  title: StringManager.editCarProfile,
                  onTap: () {
                    // TODO: Implement car profile editing
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.language_outlined,
                  title: StringManager.editLanguage,
                  onTap: () {
                    // TODO: Implement language selection
                  },
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.dark_mode_outlined,
                  title: StringManager.darkTheme,
                  trailing: Switch(
                    value: false, // TODO: Connect to theme state
                    onChanged: (value) {
                      // TODO: Implement theme switching
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout button with confirmation
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  _showLogoutConfirmation(context, onLogoutPressed),
              icon: const Icon(Icons.logout_outlined, color: Colors.red),
              label: Text(
                StringManager.singOut,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 68,
      endIndent: 20,
    );
  }

  void _showLogoutConfirmation(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_outlined, color: Colors.red),
              SizedBox(width: 12),
              Text('Logout'),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
