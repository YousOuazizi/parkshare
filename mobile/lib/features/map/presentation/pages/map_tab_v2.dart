import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/google_map_widget.dart';

class MapTabV2 extends StatefulWidget {
  const MapTabV2({super.key});

  @override
  State<MapTabV2> createState() => _MapTabV2State();
}

class _MapTabV2State extends State<MapTabV2> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedParkingId;

  // Données de démo - TODO: Récupérer du backend
  final List<ParkingMarker> _parkings = [
    ParkingMarker(
      id: '1',
      name: 'Parking Centre Ville',
      position: const LatLng(48.8566, 2.3522),
      price: 3.50,
      distance: '0.5 km',
      isAvailable: true,
    ),
    ParkingMarker(
      id: '2',
      name: 'Parking Gare du Nord',
      position: const LatLng(48.8809, 2.3553),
      price: 4.00,
      distance: '2.8 km',
      isAvailable: true,
    ),
    ParkingMarker(
      id: '3',
      name: 'Parking Bastille',
      position: const LatLng(48.8532, 2.3690),
      price: 3.00,
      distance: '1.5 km',
      isAvailable: false,
    ),
    ParkingMarker(
      id: '4',
      name: 'Parking République',
      position: const LatLng(48.8675, 2.3633),
      price: 3.80,
      distance: '1.2 km',
      isAvailable: true,
    ),
    ParkingMarker(
      id: '5',
      name: 'Parking Nation',
      position: const LatLng(48.8484, 2.3952),
      price: 2.80,
      distance: '3.5 km',
      isAvailable: true,
    ),
  ];

  List<ParkingMarker> get _nearbyParkings {
    // TODO: Filtrer par distance de la caméra
    return _parkings.take(3).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Maps
          GoogleMapWidget(
            parkings: _parkings,
            onParkingTap: (parkingId) {
              setState(() => _selectedParkingId = parkingId);
            },
          ),

          // Barre de recherche en haut
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher une adresse...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.primaryColor,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: AppTheme.primaryColor,
                          ),
                          onPressed: () {
                            _showFiltersModal();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        // TODO: Autocomplete adresse
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2, end: 0),
                ],
              ),
            ),
          ),

          // Liste des parkings à proximité en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Titre
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_nearbyParkings.length} parkings à proximité',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Afficher tous
                          },
                          child: const Text('Voir tous'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Liste
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      shrinkWrap: true,
                      itemCount: _nearbyParkings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final parking = _nearbyParkings[index];
                        return _MapParkingCard(
                          parking: parking,
                          isSelected: _selectedParkingId == parking.id,
                          onTap: () {
                            context.go('/parking/${parking.id}');
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
          ),
        ],
      ),
    );
  }

  void _showFiltersModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FiltersModal(),
    );
  }
}

class _MapParkingCard extends StatelessWidget {
  final ParkingMarker parking;
  final bool isSelected;
  final VoidCallback onTap;

  const _MapParkingCard({
    required this.parking,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_parking_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        parking.distance,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '€${parking.price.toStringAsFixed(2)}/h',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: parking.isAvailable
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    parking.isAvailable ? 'Dispo' : 'Complet',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: parking.isAvailable
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersModal extends StatefulWidget {
  const _FiltersModal();

  @override
  State<_FiltersModal> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<_FiltersModal> {
  RangeValues _priceRange = const RangeValues(0, 10);
  double _maxDistance = 5;
  bool _coverOnly = false;
  bool _securedOnly = false;
  bool _evChargingOnly = false;
  bool _available24h = false;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtres',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Prix
            Text(
              'Prix (€/heure)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 20,
              divisions: 40,
              labels: RangeLabels(
                '€${_priceRange.start.toStringAsFixed(1)}',
                '€${_priceRange.end.toStringAsFixed(1)}',
              ),
              onChanged: (values) {
                setState(() => _priceRange = values);
              },
            ),

            const SizedBox(height: 16),

            // Distance
            Text(
              'Distance maximale: ${_maxDistance.toStringAsFixed(1)} km',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Slider(
              value: _maxDistance,
              min: 0.5,
              max: 10,
              divisions: 19,
              label: '${_maxDistance.toStringAsFixed(1)} km',
              onChanged: (value) {
                setState(() => _maxDistance = value);
              },
            ),

            const SizedBox(height: 24),

            // Équipements
            Text(
              'Équipements',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              title: const Text('Couvert uniquement'),
              value: _coverOnly,
              onChanged: (value) {
                setState(() => _coverOnly = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            CheckboxListTile(
              title: const Text('Sécurisé uniquement'),
              value: _securedOnly,
              onChanged: (value) {
                setState(() => _securedOnly = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            CheckboxListTile(
              title: const Text('Borne de recharge électrique'),
              value: _evChargingOnly,
              onChanged: (value) {
                setState(() => _evChargingOnly = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            CheckboxListTile(
              title: const Text('Disponible 24/7'),
              value: _available24h,
              onChanged: (value) {
                setState(() => _available24h = value ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 24),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(0, 10);
                        _maxDistance = 5;
                        _coverOnly = false;
                        _securedOnly = false;
                        _evChargingOnly = false;
                        _available24h = false;
                      });
                    },
                    child: const Text('Réinitialiser'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Appliquer les filtres
                      Navigator.pop(context);
                    },
                    child: const Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
