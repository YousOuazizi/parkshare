import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/swap_listing.dart';
import '../widgets/swap_listing_card.dart';

class SpotSwapTab extends StatefulWidget {
  const SpotSwapTab({super.key});

  @override
  State<SpotSwapTab> createState() => _SpotSwapTabState();
}

class _SpotSwapTabState extends State<SpotSwapTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données de démo - TODO: Récupérer du backend
  final List<SwapListing> _availableSwaps = [
    SwapListing(
      id: '1',
      userId: 'user1',
      parkingId: 'p1',
      parkingName: 'Parking Centre Ville',
      location: '10 Rue de la Paix, Paris',
      availableFrom: DateTime.now().add(const Duration(days: 2)),
      availableTo: DateTime.now().add(const Duration(days: 7)),
      description:
          'Je pars en vacances, ma place est disponible pour échange',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SwapListing(
      id: '2',
      userId: 'user2',
      parkingId: 'p2',
      parkingName: 'Parking Gare',
      location: '25 Avenue de la Gare, Paris',
      availableFrom: DateTime.now().add(const Duration(days: 1)),
      availableTo: DateTime.now().add(const Duration(days: 5)),
      description: 'Télétravail cette semaine, place libre',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final List<SwapListing> _mySwaps = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SpotSwap',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                          const SizedBox(height: 4),
                          Text(
                            'Échangez votre place de parking',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _showCreateSwapModal,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 600.ms)
                          .scale(begin: const Offset(0.8, 0.8)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.secondaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.swap_horiz_rounded,
                            color: AppTheme.secondaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Échangez temporairement votre place avec d\'autres utilisateurs',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Disponibles'),
                  Tab(text: 'Mes échanges'),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 20),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAvailableSwaps(),
                  _buildMySwaps(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSwaps() {
    if (_availableSwaps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun échange disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _availableSwaps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SwapListingCard(
            listing: _availableSwaps[index],
            onTap: () => _showSwapDetails(_availableSwaps[index]),
          )
              .animate()
              .fadeIn(delay: (500 + index * 100).ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
        );
      },
    );
  }

  Widget _buildMySwaps() {
    if (_mySwaps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun échange en cours',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showCreateSwapModal,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Créer un échange'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _mySwaps.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SwapListingCard(
            listing: _mySwaps[index],
            isOwner: true,
            onTap: () => _showSwapDetails(_mySwaps[index]),
          ),
        );
      },
    );
  }

  void _showCreateSwapModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateSwapModal(
        onSubmit: (parking, from, to, description) {
          // TODO: Créer swap listing
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échange créé avec succès !'),
            ),
          );
        },
      ),
    );
  }

  void _showSwapDetails(SwapListing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SwapDetailsModal(
        listing: listing,
        onPropose: () {
          Navigator.pop(context);
          _showProposeSwapModal(listing);
        },
      ),
    );
  }

  void _showProposeSwapModal(SwapListing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProposeSwapModal(
        listing: listing,
        onSubmit: (myParkingId, message) {
          // TODO: Proposer swap
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proposition envoyée !'),
            ),
          );
        },
      ),
    );
  }
}

// Les modaux seront implémentés séparément
class _CreateSwapModal extends StatelessWidget {
  final Function(String parking, DateTime from, DateTime to, String description)
      onSubmit;

  const _CreateSwapModal({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Créer un échange',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const Text('Modal en construction...'),
            // TODO: Formulaire complet
          ],
        ),
      ),
    );
  }
}

class _SwapDetailsModal extends StatelessWidget {
  final SwapListing listing;
  final VoidCallback onPropose;

  const _SwapDetailsModal({
    required this.listing,
    required this.onPropose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              listing.parkingName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // TODO: Détails complets
          ],
        ),
      ),
    );
  }
}

class _ProposeSwapModal extends StatelessWidget {
  final SwapListing listing;
  final Function(String myParkingId, String message) onSubmit;

  const _ProposeSwapModal({
    required this.listing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Proposer un échange',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // TODO: Formulaire de proposition
          ],
        ),
      ),
    );
  }
}
