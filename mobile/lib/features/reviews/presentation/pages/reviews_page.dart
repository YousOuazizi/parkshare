import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/review.dart';
import '../widgets/review_card.dart';
import '../widgets/rating_summary.dart';

class ReviewsPage extends StatefulWidget {
  final String parkingId;
  final String parkingName;

  const ReviewsPage({
    super.key,
    required this.parkingId,
    required this.parkingName,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  // TODO: Récupérer depuis le backend
  final List<Review> _reviews = [
    Review(
      id: '1',
      userId: 'user1',
      userName: 'Marie Dupont',
      userAvatar: null,
      parkingId: '1',
      rating: 5.0,
      comment:
          'Excellent parking ! Très bien situé, sécurisé et facile d\'accès. Je recommande vivement.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      photos: [],
    ),
    Review(
      id: '2',
      userId: 'user2',
      userName: 'Jean Martin',
      userAvatar: null,
      parkingId: '1',
      rating: 4.0,
      comment:
          'Bon parking dans l\'ensemble. Un peu cher mais très pratique pour le centre-ville.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      photos: [],
    ),
    Review(
      id: '3',
      userId: 'user3',
      userName: 'Sophie Bernard',
      userAvatar: null,
      parkingId: '1',
      rating: 5.0,
      comment: 'Parfait ! Places larges, bien éclairé. Je reviendrai.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      photos: [],
    ),
    Review(
      id: '4',
      userId: 'user4',
      userName: 'Thomas Dubois',
      userAvatar: null,
      parkingId: '1',
      rating: 3.0,
      comment:
          'Correct mais un peu difficile d\'accès aux heures de pointe.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      photos: [],
    ),
  ];

  double get _averageRating {
    if (_reviews.isEmpty) return 0.0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  Map<int, int> get _ratingDistribution {
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in _reviews) {
      distribution[review.rating.round()] =
          (distribution[review.rating.round()] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RatingSummary(
                averageRating: _averageRating,
                totalReviews: _reviews.length,
                ratingDistribution: _ratingDistribution,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          ),

          // Bouton écrire un avis
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showWriteReviewModal();
                  },
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Écrire un avis'),
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Liste des avis
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReviewCard(review: _reviews[index])
                        .animate()
                        .fadeIn(delay: (200 + index * 50).ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                  );
                },
                childCount: _reviews.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showWriteReviewModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WriteReviewModal(
        parkingName: widget.parkingName,
        onSubmit: (rating, comment) {
          // TODO: Envoyer au backend
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Merci pour votre avis !'),
            ),
          );
        },
      ),
    );
  }
}

class _WriteReviewModal extends StatefulWidget {
  final String parkingName;
  final Function(double rating, String comment) onSubmit;

  const _WriteReviewModal({
    required this.parkingName,
    required this.onSubmit,
  });

  @override
  State<_WriteReviewModal> createState() => _WriteReviewModalState();
}

class _WriteReviewModalState extends State<_WriteReviewModal> {
  double _rating = 5.0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Évaluer ${widget.parkingName}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Rating
              Center(
                child: Column(
                  children: [
                    Text(
                      'Votre note',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 40,
                          icon: Icon(
                            index < _rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppTheme.warningColor,
                          ),
                          onPressed: () {
                            setState(() => _rating = index + 1.0);
                          },
                        );
                      }),
                    ),
                    Text(
                      _getRatingText(_rating),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Commentaire
              Text(
                'Votre commentaire',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Partagez votre expérience avec ce parking...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bouton soumettre
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez ajouter un commentaire'),
                        ),
                      );
                      return;
                    }
                    widget.onSubmit(_rating, _commentController.text.trim());
                  },
                  child: const Text('Publier l\'avis'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    switch (rating.round()) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Très bien';
      case 3:
        return 'Bien';
      case 2:
        return 'Moyen';
      case 1:
        return 'Mauvais';
      default:
        return '';
    }
  }
}
