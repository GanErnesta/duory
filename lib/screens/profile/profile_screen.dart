import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final viewModel = context.read<AuthViewModel>();

    await viewModel.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (image == null) return;

      if (!context.mounted) return;

      final bytes = await image.readAsBytes();

      if (!context.mounted) return;

      final viewModel = context.read<AuthViewModel>();

      final success = await viewModel.uploadAvatar(bytes);

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Foto profil berhasil diperbarui.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ??
                  'Gagal mengunggah foto.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal memilih atau mengunggah foto.',
          ),
        ),
      );
    }
  }

  Future<void> _deleteAvatar(
    BuildContext context,
  ) async {
    final viewModel = context.read<AuthViewModel>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            'Hapus foto profil?',
            style: AppTextStyles.bold20.copyWith(
              color: const Color(0xFF181818),
            ),
          ),
          content: Text(
            'Foto profil akan dihapus dan kembali ke foto default.',
            style: AppTextStyles.regular14.copyWith(
              color: const Color(0xFF555555),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final success = await viewModel.deleteAvatar();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto profil berhasil dihapus.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ??
                'Gagal menghapus foto.',
          ),
        ),
      );
    }
  }

  void _showAvatarOptions(
    BuildContext context,
    AuthViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  title: const Text(
                    'Pilih dari galeri',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(context);
                  },
                ),
                if (viewModel.avatarUrl != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                    ),
                    title: const Text(
                      'Hapus foto profil',
                    ),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _deleteAvatar(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    AuthViewModel viewModel,
  ) {
    final controller = TextEditingController(
      text: viewModel.displayName,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            'Edit Nama',
            style: AppTextStyles.bold20.copyWith(
              color: const Color(0xFF181818),
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Nama lengkap',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final name =
                          controller.text.trim();

                      if (name.isEmpty) {
                        return;
                      }

                      final success =
                          await viewModel.updateProfile(
                        fullName: name,
                      );

                      if (!dialogContext.mounted) {
                        return;
                      }

                      Navigator.pop(dialogContext);

                      if (!success &&
                          context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              viewModel.errorMessage ??
                                  'Gagal mengubah nama.',
                            ),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, _) {
        final avatarUrl = viewModel.avatarUrl;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Profil',
              style: AppTextStyles.bold20.copyWith(
                color: const Color(0xFF181818),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: viewModel.isLoading
                      ? null
                      : () {
                          _showAvatarOptions(
                            context,
                            viewModel,
                          );
                        },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor:
                            AppColors.blueLightActive,
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 52,
                                color:
                                    AppColors.blueDark,
                              )
                            : null,
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  viewModel.displayName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold20.copyWith(
                    color: const Color(0xFF181818),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  viewModel.currentUser?.email ?? '-',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular14.copyWith(
                    color: const Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () {
                            _showEditNameDialog(
                              context,
                              viewModel,
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Edit Profil',
                      style:
                          AppTextStyles.regular16.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'Logout',
                            style: AppTextStyles
                                .regular16
                                .copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}