# Lot 1 · Étape 3 — Catalogue dans l'app

Date : 3 novembre 2026

## Ce qui est fait
- **Accueil** (maquette 3) :
  - choix de la wilaya en haut (liste des 69, ouvertes d'abord ; gardée sur le téléphone et sur le compte) ;
  - grande carte « À la une », types de sortie, rangées Ce week-end, À la une, Trésors cachés et Nouveautés ;
  - carte **Wilaya du jour** ; envies (les tiennes entourées) ;
  - chaque élément ouvre Explorer avec le bon filtre.
- **Explorer** (maquettes 4 et 5) :
  - recherche ; filtres rapides **Près de moi** (position du téléphone, tri par distance), Ce week-end, Gratuit, En famille, Trésor caché ;
  - feuille **Filtres** : wilaya, quand, envie, type, prix, cadre, entre femmes, PMR, tri ;
  - **Liste** avec défilement infini, ou **Carte** OpenStreetMap avec les pastilles de prix qui ouvrent la fiche.
- **Fiche sortie** (maquette 6) :
  - photos à faire défiler, labels, organisateur (note, abonnés), date et lieu ;
  - description, météo pour le plein air ;
  - séances avec les places et points de ramassage, billets et prix, mode de vente, annulation, maximum par personne ;
  - infos propres au type, programme, inclus ;
  - lieu sur la carte et **itinéraire** (Google Maps) ;
  - **favori**, **partage** (feuille du téléphone : WhatsApp, Instagram, TikTok…), **Signaler** ; sorties dans le même esprit.
- **Page organisateur** : couverture, badge Vérifié, note, **S'abonner**, à propos, sorties à venir, contact, Signaler.
- **Favoris** (maquette 11) : la liste réelle, les sorties passées grisées.
- Sans compte, le favori, l'abonnement et le signalement ouvrent la connexion.
- Dates à l'heure d'Alger, en arabe avec des chiffres latins ; pluriels justes (« 1 sortie », « 12 sorties »).
- Autorisations de localisation ajoutées (Android et iOS, seulement quand l'app est ouverte).

## Tests
- 9 tests :
  - accueil avec À la une et Ce week-end ;
  - un type de l'accueil ouvre Explorer filtré ;
  - fiche avec les infos du type et le favori qui demande un compte ;
  - les parcours de connexion du lot 0.
- Parcours vérifié sur la version web (390 px) contre le backend local : accueil, Explorer (41 sorties), carte, fiche.
- `flutter analyze` ne signale rien.

## À vérifier de ton côté (à la fin, avec le guide de test)
- `flutter pub get` puis `flutter run` : accueil → choisir Oran en haut ; Explorer → Près de moi (autoriser la position) ; Carte ; une fiche → cœur, Partager, Itinéraire ; page de l'organisateur → S'abonner.
