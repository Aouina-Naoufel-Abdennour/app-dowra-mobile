# Lot 4 · étape 3 — App : espace organisateur, places numérotées, code promo

## Ce qui change
- **Profil** : nouvelle entrée « Espace organisateur ». Elle ouvre le site Dowra sur `/{langue}/pro`, où se trouvent les événements, les réservations, la promotion, l'équipe, la vérification et l'argent.
  - Adresse du site réglable avec `--dart-define=SITE_URL` (en local : le site Next.js sur le port 3000).
  - Le mode scan de l'équipe d'accueil reste dans l'app.
- **Réserver** :
  - **Plan de salle** pour les billets numérotés (`GET /sessions/{id}/seats`) :
    - une section par catégorie, puis les rangs, avec la scène en haut ;
    - places libres, prises ou à toi ; on choisit d'abord la catégorie de billet ;
    - le nombre de places touchées donne la quantité de billets, dans les limites : maximum par personne, places restantes.
  - **Code promo** (facultatif), envoyé en majuscules ; la remise s'applique à la validation.
  - **Offre de groupe** affichée, et remise déduite du total.
  - **Navette payante** : prix par point de ramassage, ajouté au total.
- **Fiche** : chaque partage est compté pour les statistiques de l'organisateur.

## Tests
- Nouveau test « places numérotées » :
  - la place prise ne réagit pas ;
  - deux places libres donnent 2 billets ;
  - les places et le code promo sont envoyés à l'API.
- 16 tests passent ; `flutter analyze` ne signale rien.
