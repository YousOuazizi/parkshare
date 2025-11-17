class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String parkingId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final List<String> photos;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.parkingId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.photos = const [],
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      parkingId: json['parkingId'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      photos: List<String>.from(json['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'parkingId': parkingId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'photos': photos,
    };
  }
}
