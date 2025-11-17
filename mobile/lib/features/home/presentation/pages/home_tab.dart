import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/parking_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chip_widget.dart';
import '../widgets/parking_card_widget.dart';
import '../widgets/featured_parking_card.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final List<String> _categories = [
    'Tous',
    'À proximité',
    'Abordables',
    'Couverts',
    'Sécurisés',
    'EV Charging',
  ];

  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final parkingsAsync = ref.watch(parkingsProvider);
    final userName = authState.user?.firstName ?? 'Utilisateur';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour, $userName 👋',
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
                              'Trouvez votre parking idéal',
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
                        // Notification button
                        Container(
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
                          child: IconButton(
                            icon: Stack(
                              children: [
                                const Icon(Icons.notifications_outlined),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.errorColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Notifications bientôt disponibles'),
                                ),
                              );
                            },
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 600.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search bar
                    const SearchBarWidget()
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CategoryChipWidget(
                        label: _categories[index],
                        isSelected: _selectedCategory == index,
                        onTap: () {
                          setState(() => _selectedCategory = index);
                        },
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Featured section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'À la une',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/main', extra: 1); // Navigate to map tab
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
            ),

            // Featured parkings
            SliverToBoxAdapter(
              child: SizedBox(
                height: 260,
                child: parkingsAsync.when(
                  data: (parkings) {
                    final featuredParkings = parkings.take(5).toList();
                    if (featuredParkings.isEmpty) {
                      return const Center(
                        child: Text('Aucun parking disponible'),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featuredParkings.length,
                      itemBuilder: (context, index) {
                        final parking = featuredParkings[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: FeaturedParkingCard(
                            imageUrl: parking.images.isNotEmpty
                                ? parking.images.first
                                : 'https://picsum.photos/seed/${parking.id}/400/300',
                            name: parking.name,
                            address: parking.address,
                            price: parking.pricePerHour.toStringAsFixed(2),
                            rating: parking.averageRating,
                            distance: '0.5 km', // TODO: Calculate from user location
                            onTap: () {
                              context.go('/parking/${parking.id}');
                            },
                          )
                              .animate()
                              .fadeIn(delay: (600 + index * 100).ms, duration: 600.ms)
                              .slideX(begin: 0.2, end: 0),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Erreur: ${error.toString()}'),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Nearby section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'À proximité',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/main', extra: 1); // Navigate to map tab
                      },
                      child: const Text('Voir sur la carte'),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
            ),

            // Nearby parkings list
            parkingsAsync.when(
              data: (parkings) {
                final nearbyParkings = parkings.skip(5).take(10).toList();
                if (nearbyParkings.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('Aucun parking à proximité'),
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final parking = nearbyParkings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ParkingCardWidget(
                            imageUrl: parking.images.isNotEmpty
                                ? parking.images.first
                                : 'https://picsum.photos/seed/${parking.id}/400/300',
                            name: parking.name,
                            address: parking.address,
                            price: parking.pricePerHour.toStringAsFixed(2),
                            rating: parking.averageRating,
                            distance: '1.0 km', // TODO: Calculate from user location
                            isAvailable: parking.isActive,
                            features: parking.features,
                            onTap: () {
                              context.go('/parking/${parking.id}');
                            },
                          )
                              .animate()
                              .fadeIn(delay: (1100 + index * 100).ms, duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                        );
                      },
                      childCount: nearbyParkings.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text('Erreur: ${error.toString()}'),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
