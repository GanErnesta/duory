import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/partner_viewmodel.dart';

class AccountPartnerScreen extends StatefulWidget {
  const AccountPartnerScreen({super.key});

  @override
  State<AccountPartnerScreen> createState() => _AccountPartnerScreenState();
}

class _AccountPartnerScreenState extends State<AccountPartnerScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final user = context.read<AuthViewModel>().currentUser;

      if (user != null) {
        context.read<PartnerViewModel>().initialize(user.id);
      }
    });
  }

  Future<void> _refresh() async {
    final user = context.read<AuthViewModel>().currentUser;

    if (user == null) return;

    await context.read<PartnerViewModel>().refresh(user.id);
  }

  Future<void> _copyPairCode(String pairCode) async {
    await Clipboard.setData(ClipboardData(text: pairCode));

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kode berhasil disalin.')));
  }

  void _showConnectPartnerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const _ConnectPartnerSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, PartnerViewModel>(
      builder: (context, authViewModel, partnerViewModel, _) {
        final avatarUrl = authViewModel.avatarUrl;

        final partnerAvatar = partnerViewModel.partnerAvatar;

        final pairCode = partnerViewModel.pairCode;

        final isConnected = partnerViewModel.isConnected;

        final partnerName = partnerViewModel.partnerName;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF181818),
              ),
            ),
            title: Text(
              'Akun & Pasangan',
              style: AppTextStyles.bold20.copyWith(
                color: const Color(0xFF181818),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PartnerHeader(
                    userName: authViewModel.displayName,
                    avatarUrl: avatarUrl,
                    partnerName: partnerName,
                    partnerAvatarUrl: partnerAvatar,
                    isConnected: isConnected,
                    onAddPartner: _showConnectPartnerModal,
                  ),
                  const SizedBox(height: 24),
                  _PairCodeItem(
                    pairCode: pairCode,
                    connected: isConnected,
                    loading: partnerViewModel.isLoading,
                    onCopy: pairCode != null && pairCode.isNotEmpty
                        ? () => _copyPairCode(pairCode)
                        : null,
                    onConnect: _showConnectPartnerModal,
                  ),
                  const SizedBox(height: 24),
                  if (partnerViewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEEEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          partnerViewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    'Edit data diri',
                    style: AppTextStyles.semibold14.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _ProfileDataItem(
                    title: 'Nama Panggilan',
                    value: authViewModel.displayName,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _ProfileDataItem(
                    title: 'Tanggal Lahir',
                    value: '9 Mei 2006',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _ProfileDataItem(
                    title: 'Foto Profil',
                    trailing: avatarUrl != null && avatarUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(avatarUrl),
                          )
                        : const CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFFE0E0E0),
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Color(0xFF888888),
                            ),
                          ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Milestone kalian',
                    style: AppTextStyles.semibold14.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MilestoneCard(
                          title: 'Anniversary',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _MilestoneCard(
                          title: 'Daily quiz streak',
                          onTap: () {},
                        ),
                      ),
                    ],
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

class _ConnectPartnerSheet extends StatefulWidget {
  const _ConnectPartnerSheet();

  @override
  State<_ConnectPartnerSheet> createState() => _ConnectPartnerSheetState();
}

class _ConnectPartnerSheetState extends State<_ConnectPartnerSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final code = _controller.text.trim().toUpperCase();

    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Masukkan kode pasangan.')));
      return;
    }

    final authViewModel = context.read<AuthViewModel>();

    final partnerViewModel = context.read<PartnerViewModel>();

    final user = authViewModel.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User belum login.')));
      return;
    }

    FocusScope.of(context).unfocus();

    partnerViewModel.clearError();

    final success = await partnerViewModel.connectPartner(
      code: code,
      userId: user.id,
    );

    if (!mounted) return;

    if (!success) {
      final error = partnerViewModel.errorMessage;

      if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }

      return;
    }

    await partnerViewModel.refresh(user.id);

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Akun berhasil terhubung.')));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerViewModel>(
      builder: (context, partnerViewModel, _) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Masukkan kode pasangan',
                      style: AppTextStyles.bold20.copyWith(
                        color: const Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masukkan kode yang diberikan oleh pasanganmu\n'
                      'untuk terhubung',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF252525),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      enabled: !partnerViewModel.isLoading,
                      autofocus: true,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        if (partnerViewModel.errorMessage != null) {
                          partnerViewModel.clearError();
                        }
                      },
                      onSubmitted: (_) {
                        if (!partnerViewModel.isLoading) {
                          _connect();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Contoh: NSY_KDR59',
                        hintStyle: AppTextStyles.regular14.copyWith(
                          color: const Color(0xFFAAAAAA),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                        onPressed: partnerViewModel.isLoading ? null : _connect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: partnerViewModel.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Hubungkan',
                                style: AppTextStyles.regular16.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: partnerViewModel.isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(color: AppColors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: AppTextStyles.regular16.copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PartnerHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final String? partnerName;
  final String? partnerAvatarUrl;
  final bool isConnected;
  final VoidCallback onAddPartner;

  const _PartnerHeader({
    required this.userName,
    required this.avatarUrl,
    required this.partnerName,
    required this.partnerAvatarUrl,
    required this.isConnected,
    required this.onAddPartner,
  });

  @override
  Widget build(BuildContext context) {
    final displayedPartnerName =
        partnerName != null && partnerName!.trim().isNotEmpty
        ? partnerName!
        : 'Tambah pasangan';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Avatar(avatarUrl: avatarUrl, borderColor: AppColors.red),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(height: 1, color: AppColors.red),
                  Container(
                    width: 36,
                    height: 36,
                    color: AppColors.white,
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isConnected ? null : onAddPartner,
              child: _Avatar(
                avatarUrl: partnerAvatarUrl,
                borderColor: const Color(0xFF8AA1B5),
                showAdd: !isConnected,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                userName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
            const SizedBox(width: 44),
            SizedBox(
              width: 110,
              child: Text(
                displayedPartnerName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isConnected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFBCE8C8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Akun terhubung',
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF181818),
              ),
            ),
          )
        else
          Text(
            'Akun anda belum terhubung dengan\n'
            'pasangan anda',
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12.copyWith(
              color: const Color(0xFF252525),
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final Color borderColor;
  final bool showAdd;

  const _Avatar({
    required this.avatarUrl,
    required this.borderColor,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: ClipOval(
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _defaultAvatar();
                },
              )
            : _defaultAvatar(),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFFBDBDBD),
      child: Icon(
        showAdd ? Icons.add : Icons.person,
        size: showAdd ? 32 : 45,
        color: const Color(0xFF444444),
      ),
    );
  }
}

class _PairCodeItem extends StatelessWidget {
  final String? pairCode;
  final bool connected;
  final bool loading;
  final VoidCallback? onCopy;
  final VoidCallback? onConnect;

  const _PairCodeItem({
    required this.pairCode,
    required this.connected,
    required this.loading,
    this.onCopy,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final hasCode = pairCode != null && pairCode!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pair code',
                  style: AppTextStyles.semibold14.copyWith(
                    color: const Color(0xFF181818),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  connected
                      ? 'Kode pasangan kamu'
                      : 'Bagikan kode ini ke pasangan\n'
                            'agar terhubung',
                  style: AppTextStyles.regular12.copyWith(
                    color: const Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
          if (loading && !hasCode)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.red,
              ),
            )
          else if (hasCode)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E1D8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.redLightActive),
                  ),
                  child: Text(
                    pairCode!,
                    style: AppTextStyles.regular12.copyWith(
                      color: const Color(0xFF555555),
                    ),
                  ),
                ),
                if (!connected)
                  TextButton(
                    onPressed: onCopy,
                    child: Text(
                      'Salin',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ),
              ],
            )
          else if (!connected)
            GestureDetector(
              onTap: onConnect,
              child: const Icon(
                Icons.chevron_right,
                size: 22,
                color: Color(0xFF181818),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileDataItem extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileDataItem({
    required this.title,
    this.value,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null)
              Text(value!, style: AppTextStyles.regular12),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right, size: 22),
          ],
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MilestoneCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.redLightActive),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyles.regular12.copyWith(
            color: const Color(0xFF252525),
          ),
        ),
      ),
    );
  }
}
