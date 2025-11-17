class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';

  // Parkings
  static const String parkings = '/parkings';
  static String parkingById(String id) => '/parkings/$id';
  static const String searchParkings = '/parkings/search';
  static String checkAvailability(String id) => '/parkings/$id/check-availability';

  // Bookings
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';

  // Reviews
  static const String reviews = '/reviews';
  static String reviewsByParkingId(String parkingId) => '/reviews/parking/$parkingId';

  // Payments
  static const String paymentMethods = '/payments/methods';
  static const String createPaymentIntent = '/payments/intent';
  static const String confirmPayment = '/payments/confirm';

  // Notifications
  static const String notifications = '/notifications';
  static String markAsRead(String id) => '/notifications/$id/read';
  static const String updateFcmToken = '/notifications/fcm-token';

  // SpotSwap
  static const String swapListings = '/spotswap/listings';
  static const String swapOffers = '/spotswap/offers';
  static String acceptSwapOffer(String id) => '/spotswap/offers/$id/accept';
  static String rejectSwapOffer(String id) => '/spotswap/offers/$id/reject';

  // Analytics
  static const String ownerStats = '/analytics/owner/stats';
  static const String ownerRevenue = '/analytics/owner/revenue';
  static const String ownerBookings = '/analytics/owner/bookings';

  // Verification
  static const String submitVerification = '/verification/submit';
  static const String verificationStatus = '/verification/status';

  // GDPR
  static const String exportData = '/gdpr/export';
  static const String deleteAccount = '/gdpr/delete-account';

  // Subscriptions
  static const String subscriptionPlans = '/subscriptions/plans';
  static const String subscribe = '/subscriptions/subscribe';
  static const String cancelSubscription = '/subscriptions/cancel';
}
