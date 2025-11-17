import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chip_widget.dart';
import '../widgets/parking_card_widget.dart';
import '../widgets/featured_parking_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
                              'Bonjour, John 👋',
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
                              // TODO: Navigate to notifications
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
                        // TODO: Navigate to all featured
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: FeaturedParkingCard(
                        imageUrl: 'https://picsum.photos/seed/$index/400/300',
                        name: 'Parking Centre Ville ${index + 1}',
                        address: '${10 + index} Rue de la Paix, Paris',
                        price: '${3 + index}.50',
                        rating: 4.5 + (index * 0.1),
                        distance: '${0.5 + (index * 0.2)} km',
                        onTap: () {
                          context.go('/parking/${index + 1}');
                        },
                      )
                          .animate()
                          .fadeIn(delay: (600 + index * 100).ms, duration: 600.ms)
                          .slideX(begin: 0.2, end: 0),
                    );
                  },
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
                        // TODO: Navigate to map view
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ParkingCardWidget(
                        imageUrl: 'https://picsum.photos/seed/${index + 10}/400/300',
                        name: 'Parking Gare ${index + 1}',
                        address: '${20 + index} Avenue de la Gare, Paris',
                        price: '${4 + index}.00',
                        rating: 4.3 + (index * 0.15),
                        distance: '${1.0 + (index * 0.3)} km',
                        isAvailable: index % 3 != 0,
                        features: const ['Couvert', 'Sécurisé', '24/7'],
                        onTap: () {
                          context.go('/parking/${index + 10}');
                        },
                      )
                          .animate()
                          .fadeIn(delay: (1100 + index * 100).ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0),
                    );
                  },
                  childCount: 10,
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
