# Dowra — Application mobile

Application Flutter de **Dowra** pour iOS et Android (et version web pour les tests), en français, arabe (de droite à gauche) et anglais, en mode clair, sombre ou système. Le mode scan des billets pour les équipes d'accueil arrive avec la billetterie (lot 2).

| Identifiant | `dz.dowra.app` |
|---|---|
| **Versions** | Flutter 3.47 (Dart 3.13), Riverpod 3, go_router 18, Dio 5, flutter_secure_storage 11, flutter_map (OpenStreetMap), geolocator, share_plus, qr_flutter, mobile_scanner, shared_preferences, textes en ARB (fr, ar, en) |
| **Polices intégrées** | Plus Jakarta Sans, Caveat, Noto Kufi Arabic |

## Démarrer (Android Studio ou terminal)

Prérequis : Flutter 3.47 et le backend `app-dowra-backend` lancé sur le port 8000.

```powershell
git pull
flutter pub get
flutter run
```

L'app appelle l'API à :
- émulateur Android : `http://10.0.2.2:8000/api/v1` (automatique) ;
- simulateur iOS et web : `http://127.0.0.1:8000/api/v1` (automatique) ;
- vrai téléphone sur le même Wi-Fi : `flutter run --dart-define=API_URL=http://IP-DE-TON-PC:8000/api/v1`.

## Comptes de test (mode debug)

Sur l'écran du numéro, le compte Utilisateur est pré-rempli et un bouton par compte remplit les autres ; le code `123456` est pré-rempli à l'écran suivant.

| Compte | Numéro |
|---|---|
| Utilisateur | 05 50 00 00 10 |
| Ambassadeur | 05 50 00 00 11 |
| Organisateur vérifié | 05 50 00 00 20 |
| Organisateur Pro | 05 50 00 00 21 |
| Organisateur non vérifié | 05 50 00 00 22 |
| Équipe d'accueil | 05 50 00 00 23 |

Un autre numéro mobile (05, 06 ou 07) crée un nouveau compte et ouvre le premier passage chez Dowri. En recette (version release), ajouter `--dart-define=DOWRA_DEMO_ACCOUNTS=true`.

## Écrans

| Écran | Adresse |
|---|---|
| Bienvenue (premier lancement, choix de la langue) | `/bienvenue` |
| Connexion : numéro, puis code SMS | `/connexion`, `/connexion/code` |
| Premier passage chez Dowri (prénom, wilaya, envies) | `/premiers-pas` |
| Onglets Accueil, Explorer, Billets, Favoris, Profil | `/accueil`, `/explorer`, `/billets`, `/favoris`, `/profil` |
| Informations personnelles | `/profil/infos` |
| Fiche d'une sortie | `/sorties/:slug` |
| Page organisateur | `/organisateurs/:slug` |
| Réserver | `/sorties/:slug/reserver` |
| Billet (QR codes) | `/billets/:code` |
| Mode scan | `/scan`, `/scan/:session` |

Sans compte, l'accueil, Explorer, les fiches et les pages organisateurs restent ouverts ; Billets, Favoris et Profil invitent à se connecter, comme le cœur, l'abonnement et le signalement.

Photos : l'API renvoie des adresses en `localhost` ; sur l'émulateur Android, l'app les réécrit vers `10.0.2.2`.

## Organisation

- `lib/core` : API (`api.dart`, `repository.dart`), session et préférences (`providers.dart`), jeton chiffré (`storage.dart`).
- `lib/l10n` : textes de l'app (`app_fr.arb`, `app_ar.arb`, `app_en.arb`), code généré par `flutter pub get`.
- `lib/theme` : charte (couleurs, clair et sombre).
- `lib/widgets` : logo, Dowri, boutons, cartes communes.
- `assets/dowri` : Dowri en 8 humeurs ; `assets/photos` : photos de lieux (crédits dans `docs/design/CREDITS-photos.md`).
- Charte : `docs/design/` ; récapitulatif de chaque étape : `docs/recaps/`.

## Commandes

| Commande | Rôle |
|---|---|
| `flutter run` | lancer l'app |
| `flutter analyze` | vérification du code |
| `flutter test` | tests |
| `flutter build web --no-web-resources-cdn` | version web de test |

## Billetterie (lot 2)
- **Réserver** depuis la fiche : séance, billets, ramassage, options, noms des participants, billet en ligne ou réservation simple. Le paiement s'ouvre dans le navigateur de l'app (page de test en local) ; au retour, le billet se met à jour.
- **Mes billets** : à venir et passés, QR code par billet, transfert à un ami (numéro ou lien), annulation, calendrier, itinéraire. Les billets sont gardés sur le téléphone et restent visibles **sans réseau** ; ils sont effacés à la déconnexion.
- **Mode scan** (Profil → Mode scan, pour les organisateurs, leur équipe d'accueil et l'équipe Dowra) : la liste des billets est téléchargée, chaque scan est jugé sur place (vert, orange, rouge), même sans réseau, puis envoyé au retour du réseau. Compte de test : « Équipe d'accueil » (05 50 00 00 23), séance « Nuit dans les dunes de Taghit ».
- Caméra : autorisation demandée au premier scan (Android `CAMERA`, iOS `NSCameraUsageDescription`). Sans caméra, le code du billet se saisit à la main.
