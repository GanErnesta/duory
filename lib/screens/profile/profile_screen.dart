import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'account_partner/account_partner_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/partner_viewmodel.dart';
import '../auth/login_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_logout.dart';
import 'widgets/profile_menu.dart';
import 'widgets/profile_stats.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePartner();
    });
  }

  Future<void> _initializePartner() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null || !mounted) return;

    await context.read<PartnerViewModel>().initialize(user.id);
  }

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

      final bytes = await image.readAsBytes();

      if (!context.mounted) return;

      final viewModel = context.read<AuthViewModel>();

      final success = await viewModel.uploadAvatar(bytes);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Foto profil berhasil diperbarui.'
                : viewModel.errorMessage ??
                    'Gagal mengunggah foto.',
          ),
        ),
      );
    } catch (_) {
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

  Future<void> _deleteAvatar(BuildContext context) async {
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
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: AppColors.white,
                elevation: 0,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Foto profil berhasil dihapus.'
              : viewModel.errorMessage ??
                  'Gagal menghapus foto.',
        ),
      ),
    );
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
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D0D0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  title: Text(
                    'Pilih dari galeri',
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF181818),
                    ),
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
                    title: Text(
                      'Hapus foto profil',
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF181818),
                      ),
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.red,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                      final name = controller.text.trim();

                      if (name.isEmpty) return;

                      final success =
                          await viewModel.updateProfile(
                        fullName: name,
                      );

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);
                      controller.dispose();

                      if (!success && context.mounted) {
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
                elevation: 0,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showConnectPartnerModal(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext)
                .viewInsets
                .bottom,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Consumer<PartnerViewModel>(
              builder: (
                context,
                partnerViewModel,
                _,
              ) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius:
                            BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Tambah pasangan',
                      style: AppTextStyles.bold20.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masukkan kode pasangan untuk\nmenghubungkan akun kalian.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: controller,
                      textCapitalization:
                          TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Contoh: NSY_KDR59',
                        hintStyle:
                            AppTextStyles.regular14.copyWith(
                          color: const Color(0xFFAAAAAA),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.red,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: partnerViewModel.isLoading
                            ? null
                            : () async {
                                final code =
                                    controller.text
                                        .trim();

                                if (code.isEmpty) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Masukkan kode pasangan.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final user = Supabase
                                    .instance
                                    .client
                                    .auth
                                    .currentUser;

                                if (user == null) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'User belum login.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final success =
                                    await partnerViewModel
                                        .connectPartner(
                                  code: code,
                                  userId: user.id,
                                );

                                if (!sheetContext.mounted) {
                                  return;
                                }

                                if (success) {
                                  Navigator.pop(
                                    sheetContext,
                                  );

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Akun berhasil terhubung.',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        partnerViewModel
                                                .errorMessage ??
                                            'Gagal menghubungkan akun.',
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: partnerViewModel.isLoading
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
                                'Hubungkan',
                                style: AppTextStyles
                                    .regular16
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed:
                            partnerViewModel.isLoading
                                ? null
                                : () {
                                    Navigator.pop(
                                      sheetContext,
                                    );
                                  },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(
                            color: AppColors.red,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style:
                              AppTextStyles.regular16.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Fitur ini sedang dalam pengembangan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              'Profil',
              style: AppTextStyles.bold20.copyWith(
                color: const Color(0xFF181818),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                24,
              ),
              child: Column(
                children: [
                  ProfileHeader(
                    onAvatarTap: () {
                      _showAvatarOptions(
                        context,
                        viewModel,
                      );
                    },
                    onEditName: () {
                      _showEditNameDialog(
                        context,
                        viewModel,
                      );
                    },
                    onAddPartner: () {
                      _showConnectPartnerModal(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  const ProfileStats(),
                  const SizedBox(height: 14),
                  ProfileMenu(
                    onAccountTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AccountPartnerScreen(),
                        ),
                      );
                    },
                    onPreferenceTap: () {
                      _showComingSoon(context);
                    },
                    onHelpTap: () {
                      _showComingSoon(context);
                    },
                    onPrivacyTap: () {
                      _showComingSoon(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  ProfileLogout(
                    isLoading: viewModel.isLoading,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}