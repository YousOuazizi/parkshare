import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/booking_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final bookingsAsync = ref.watch(bookingsProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: user?.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      user!.avatarUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    _getInitials(user?.firstName, user?.lastName),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.easeOutBack)
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 4),

                    // Email
                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 20),

                    // Stats
                    bookingsAsync.when(
                      data: (bookings) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(
                            icon: Icons.bookmark_rounded,
                            value: bookings.length.toString(),
                            label: 'Réservations',
                          ),
                          _StatItem(
                            icon: Icons.star_rounded,
                            value: user?.averageRating?.toStringAsFixed(1) ?? '0.0',
                            label: 'Note',
                          ),
                          _StatItem(
                            icon: Icons.local_parking_rounded,
                            value: '0', // TODO: Get from parking owner count
                            label: 'Parkings',
                          ),
                        ],
                      ),
                      loading: () => const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                      error: (_, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(
                            icon: Icons.bookmark_rounded,
                            value: '0',
                            label: 'Réservations',
                          ),
                          _StatItem(
                            icon: Icons.star_rounded,
                            value: '0.0',
                            label: 'Note',
                          ),
                          _StatItem(
                            icon: Icons.local_parking_rounded,
                            value: '0',
                            label: 'Parkings',
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Menu sections
              _MenuSection(
                title: 'Compte',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Modifier le profil',
                    onTap: () => context.go('/profile/edit'),
                  ),
                  _MenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Moyens de paiement',
                    onTap: () => context.go('/payment-methods'),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paramètres de notifications bientôt disponibles'),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.security_rounded,
                    title: 'Sécurité',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Paramètres de sécurité bientôt disponibles'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _MenuSection(
                title: 'Mes parkings',
                items: [
                  _MenuItem(
                    icon: Icons.add_circle_outline,
                    title: 'Ajouter un parking',
                    onTap: () {
                      context.go('/parking/add');
                    },
                  ),
                  _MenuItem(
                    icon: Icons.local_parking_outlined,
                    title: 'Gérer mes parkings',
                    onTap: () {
                      context.go('/parking/manage');
                    },
                  ),
                  _MenuItem(
                    icon: Icons.analytics_outlined,
                    title: 'Statistiques',
                    onTap: () {
                      context.go('/analytics/owner-dashboard');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _MenuSection(
                title: 'Préférences',
                items: [
                  _MenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Thème sombre',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thème sombre bientôt disponible'),
                          ),
                        );
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.language_rounded,
                    title: 'Langue',
                    trailing: Text(
                      'Français',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Changement de langue bientôt disponible'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _MenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Centre d\'aide',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Centre d\'aide bientôt disponible'),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politique de confidentialité',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Politique de confidentialité bientôt disponible'),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Conditions d\'utilisation',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Conditions d\'utilisation bientôt disponibles'),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'À propos',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('À propos de ParkShare'),
                          content: const Text('ParkShare v1.0.0\n\nL\'application de partage de places de parking la plus innovante.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Déconnexion'),
                          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.errorColor,
                              ),
                              child: const Text('Déconnecter'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Se déconnecter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: const BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String? firstName, String? lastName) {
    final first = (firstName ?? '').trim();
    final last = (lastName ?? '').trim();

    if (first.isEmpty && last.isEmpty) return 'U';
    if (first.isEmpty) return last[0].toUpperCase();
    if (last.isEmpty) return first[0].toUpperCase();

    return '${first[0]}${last[0]}'.toUpperCase();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              items.length,
              (index) => Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: Colors.grey.shade200,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
          ),
    );
  }
}
