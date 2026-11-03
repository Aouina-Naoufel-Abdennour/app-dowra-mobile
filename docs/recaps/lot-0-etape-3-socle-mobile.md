# Lot 0 · Étape 3 — Socle de l'application mobile

Date : 3 novembre 2026

## Ce qui est fait
- Projet **Flutter 3.47** (même version que Hazza), identifiant `dz.dowra.app`, Android, iOS et web.
- **Riverpod 3 et go_router**, textes en **ARB** dans 3 langues : français, arabe (toute l'app passe de droite à gauche, police Noto Kufi Arabic) et anglais. La langue du téléphone est prise au premier lancement.
- **Mode clair, sombre ou système**, gardé sur le téléphone et enregistré sur le compte.
- **Charte Dowra** :
  - dégradé mauve, jaune soleil, Plus Jakarta Sans et Caveat intégrées ;
  - logo « la boucle » ;
  - icône de l'app sur Android, iOS et web ;
  - barre de navigation flottante sombre, avec l'onglet actif en pilule dégradée.
- **Dowri partout** : bienvenue, carte de l'accueil, connexion, premier passage, billets, favoris, erreurs (Dowri triste), suppression du compte.
- **Écrans des maquettes**, avec les données de l'API :
  - Bienvenue (1) : photo de Taghit et choix de la langue ;
  - Connexion par SMS (2) : numéro, puis code ;
  - Premier passage chez Dowri : prénom, wilaya de départ (les 69, ouvertes en premier) et envies ;
  - Accueil (3) : « Salam Amina, on sort où ? », recherche, mise en avant, types de sortie, envies (les tiennes entourées), villes de départ ;
  - Explorer (4) : les 11 types de sortie, avec ce que l'on réserve ;
  - Billets (10) et Favoris (11) : vides avec Dowri, ou invitation à se connecter pour un visiteur ;
  - Profil et passeport (14) : niveau, points, ambassadeur, informations personnelles, langue, affichage, déconnexion, suppression du compte.
- **Session** : jeton chiffré (Keychain, Keystore), retrouvée au relancement ; un jeton révoqué renvoie en visiteur.
- **Comptes de test** pré-remplis en mode debug, un bouton par compte.
- CI GitHub Actions : analyse et tests.

## Corrections dans le backend
- Niveaux (Explorateur, Local Découvreur, Ambassadeur) et « ce que l'on réserve » traduits en arabe et en anglais dans l'API (22 tests).

## Tests
- 7 tests :
  - numéros algériens ;
  - premier lancement puis accueil en visiteur ;
  - passage en arabe de droite à gauche ;
  - numéro invalide refusé ;
  - nouveau compte : code SMS, premier passage chez Dowri, puis accueil à son prénom.
- Parcours vérifié dans un navigateur (version web, 390 px) contre le backend local, en clair et en sombre :
  - bienvenue → accueil en visiteur → Profil → connexion du compte Utilisateur → accueil « Salam Amina » → passeport → passage en arabe ;
  - même parcours avec le compte Ambassadeur, en sombre.

## À vérifier de ton côté
1. Backend lancé (étape 1), puis dans `app-dowra-mobile` : `git pull`, `flutter pub get`, `flutter run` sur l'émulateur Android.
2. Bienvenue → **J'ai déjà un compte** → Recevoir le code → Vérifier → accueil.
3. Profil → passer en **العربية**, puis en **Sombre**.
4. Se déconnecter, puis se connecter avec `07 70 12 34 56` → premier passage chez Dowri.

## Pas encore fait
- Écran de lancement natif aux couleurs de Dowra (avant la publication sur les stores).
- Notifications push (lot 5), mode scan des billets (lot 2).

## Étape suivante
Lot 1 · Étape 1 : catalogue des sorties dans le backend (organisateurs, sorties, départs, photos, recherche Meilisearch, 40 sorties d'exemple).
