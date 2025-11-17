import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Paris Centre',
    'Gare du Nord',
    'République',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher un parking...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          onChanged: (value) {
            // TODO: Recherche en temps réel
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              // TODO: Ouvrir filtres avancés
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Recherches récentes
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recherches récentes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('Effacer'),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 12),
            ...List.generate(
              _recentSearches.length,
              (index) => _SearchHistoryItem(
                text: _recentSearches[index],
                onTap: () {
                  _searchController.text = _recentSearches[index];
                },
                onDelete: () {
                  setState(() {
                    _recentSearches.removeAt(index);
                  });
                },
              )
                  .animate()
                  .fadeIn(delay: (100 + index * 50).ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
            ),
            const SizedBox(height: 24),
          ],

          // Suggestions populaires
          Text(
            'Recherches populaires',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PopularChip(label: 'À proximité', icon: Icons.near_me_rounded),
              _PopularChip(label: 'Moins de 3€/h', icon: Icons.euro_rounded),
              _PopularChip(
                  label: 'Couvert', icon: Icons.roofing_rounded),
              _PopularChip(
                  label: 'Sécurisé', icon: Icons.security_rounded),
              _PopularChip(
                  label: 'Borne EV', icon: Icons.electric_car_rounded),
              _PopularChip(label: 'Disponible 24/7', icon: Icons.access_time_rounded),
            ]
                .asMap()
                .entries
                .map((entry) => entry.value
                    .animate()
                    .fadeIn(delay: (400 + entry.key * 50).ms, duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SearchHistoryItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SearchHistoryItem({
    required this.text,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
              onPressed: onDelete,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PopularChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Appliquer le filtre
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
