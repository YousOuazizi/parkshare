# 🚗 ParkShare Mobile App

Application mobile Flutter moderne pour la plateforme ParkShare - Trouvez et partagez des places de parking.

## ✨ Caractéristiques

### Design & UX
- 🎨 **Material Design 3** - Interface moderne et élégante
- 🌈 **Animations fluides** - Transitions et micro-interactions
- 📱 **Navigation intuitive** - Bottom navigation avec animations
- 🎭 **Thème clair/sombre** - Support du mode sombre
- ⚡ **Performance optimale** - Hot reload et compilation rapide

### Fonctionnalités principales
- 🔐 **Authentification** - Login, Register, Social auth
- 🏠 **Accueil** - Liste des parkings disponibles avec filtres
- 🗺️ **Carte interactive** - Visualisation géographique des parkings
- 📅 **Réservations** - Système de booking complet
- 👤 **Profil utilisateur** - Gestion du compte et des préférences
- 💳 **Paiements** - Intégration Stripe, Apple Pay
- ⭐ **Avis et notes** - Système de review
- 🔔 **Notifications** - Push notifications avec Firebase

## 🏗️ Architecture

L'application suit une **Clean Architecture** avec séparation des responsabilités :

```
lib/
├── core/                     # Composants core de l'app
│   ├── theme/               # Thème Material 3
│   │   └── app_theme.dart   # Configuration des couleurs, typographie
│   ├── constants/           # Constantes de l'app
│   ├── network/             # Client HTTP (Dio)
│   ├── router/              # Navigation (GoRouter)
│   ├── utils/               # Utilitaires
│   └── widgets/             # Widgets réutilisables
│
├── features/                 # Fonctionnalités par domaine
│   ├── auth/                # Authentification
│   │   ├── presentation/    # UI (pages, widgets)
│   │   ├── domain/          # Logique métier
│   │   └── data/            # Data sources, repositories
│   │
│   ├── home/                # Page d'accueil
│   ├── parking/             # Détails des parkings
│   ├── booking/             # Réservations
│   ├── map/                 # Carte et recherche
│   ├── profile/             # Profil utilisateur
│   └── payment/             # Paiements
│
└── main.dart                # Point d'entrée de l'app
```

### Stack technique

**State Management**
- 🔄 **Riverpod** - State management moderne et performant
- 📦 **Hive** - Base de données locale
- 🔐 **Flutter Secure Storage** - Stockage sécurisé

**Networking**
- 🌐 **Dio** - Client HTTP avec intercepteurs
- 🔌 **Retrofit** - API REST typée
- 🔄 **Socket.io** - Real-time updates

**UI/UX**
- 🎬 **Flutter Animate** - Animations déclaratives
- 🎭 **Lottie** - Animations vectorielles
- 🖼️ **Cached Network Image** - Cache d'images optimisé
- ✨ **Shimmer** - Loading placeholders

**Maps & Location**
- 🗺️ **Google Maps Flutter** - Cartes interactives
- 📍 **Geolocator** - Géolocalisation
- 🏷️ **Geocoding** - Conversion adresse/coordonnées

**Other**
- 🔥 **Firebase** - Analytics, Crashlytics, Messaging
- 💳 **Stripe** - Paiements
- 📷 **Image Picker** - Sélection de photos
- 🎫 **QR Code** - Scan de QR codes

## 🚀 Installation

### Prérequis

- Flutter SDK (>=3.5.0)
- Dart SDK (>=3.5.0)
- Android Studio / Xcode
- Git

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone <repository-url>
cd parkshare/mobile
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Générer le code (models, routes, etc.)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configuration**

Créer un fichier `.env` à la racine de `mobile/` :
```env
API_BASE_URL=http://localhost:3000/api
GOOGLE_MAPS_API_KEY=your_api_key
STRIPE_PUBLISHABLE_KEY=your_stripe_key
```

5. **Lancer l'application**

iOS:
```bash
flutter run -d ios
```

Android:
```bash
flutter run -d android
```

Web:
```bash
flutter run -d chrome
```

## 📱 Écrans disponibles

### Authentification
- ✅ Splash Screen - Animation de démarrage
- ✅ Onboarding - Introduction en 3 étapes
- ✅ Login - Connexion avec email ou social
- ✅ Register - Inscription complète

### Navigation principale
- ✅ Home - Liste des parkings avec recherche et filtres
- ✅ Map - Carte interactive des parkings
- ✅ Bookings - Historique des réservations
- ✅ Profile - Gestion du compte

### Parcours de réservation
- ✅ Parking Details - Détails complets avec photos
- ✅ Booking - Sélection date/heure et paiement
- ✅ Confirmation - Page de succès

### Profil & Paramètres
- ✅ Edit Profile - Modification des infos
- ✅ Payment Methods - Gestion des moyens de paiement
- ⏳ Settings - Préférences et paramètres
- ⏳ Help & Support - Centre d'aide

## 🎨 Design System

### Couleurs principales
```dart
Primary: #6C63FF (Violet)
Secondary: #03DAC6 (Turquoise)
Error: #FF6B6B (Rouge)
Success: #51CF66 (Vert)
Warning: #FFA94D (Orange)
```

### Typographie
- Font: **Inter** (Google Fonts)
- Tailles: De 10px à 32px
- Poids: Regular (400) à Bold (700)

### Composants
- Boutons arrondis (16px radius)
- Cards avec ombres légères
- Inputs avec bordures arrondies
- Bottom navigation avec animations
- Chips pour les filtres et tags

## 🔌 Intégration Backend

L'application communique avec le backend NestJS via l'API REST :

### Configuration réseau
```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://localhost:3000/api';
```

### Endpoints principaux
- `POST /auth/login` - Connexion
- `POST /auth/register` - Inscription
- `GET /parkings` - Liste des parkings
- `GET /parkings/:id` - Détails d'un parking
- `POST /bookings` - Créer une réservation
- `GET /bookings` - Liste des réservations
- `GET /users/profile` - Profil utilisateur

### Authentification
L'app utilise JWT tokens stockés dans `FlutterSecureStorage` :
- Access token dans les headers `Authorization: Bearer <token>`
- Refresh token automatique en cas d'expiration

## 🧪 Tests

### Lancer les tests unitaires
```bash
flutter test
```

### Lancer les tests d'intégration
```bash
flutter test integration_test
```

### Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Build de production

### Android (APK)
```bash
flutter build apk --release
```

### Android (App Bundle)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔮 TODO / Roadmap

### Fonctionnalités à venir
- [ ] Intégration Google Maps complète
- [ ] Scanner de QR Code pour accès parking
- [ ] Chat en temps réel propriétaire/locataire
- [ ] Système de favoris
- [ ] Historique des transactions
- [ ] Mode hors ligne avec synchronisation
- [ ] Deep linking
- [ ] Share parking feature
- [ ] Dynamic pricing display

### Améliorations techniques
- [ ] Tests unitaires complets
- [ ] Tests d'intégration
- [ ] CI/CD pipeline
- [ ] Monitoring et analytics
- [ ] Error tracking avec Sentry
- [ ] Performance monitoring

## 📄 License

Copyright © 2024 ParkShare. All rights reserved.

## 🤝 Contribution

Pour contribuer au projet :
1. Fork le repository
2. Créer une branche (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📞 Support

Pour toute question ou problème :
- Email: support@parkshare.com
- GitHub Issues: [Créer un ticket](https://github.com/parkshare/issues)

---

**Fait avec ❤️ par l'équipe ParkShare**
