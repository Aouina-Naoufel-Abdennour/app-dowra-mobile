# Lot 3 · Étape 3 — Paiement et cartes cadeaux dans l'app

Date : 3 novembre 2026

## Ce qui est fait
- **Réserver** :
  - choix de la carte CIB ou Edahabia ;
  - frais de paiement affichés avant de payer, avec le même calcul que l'API ;
  - champ carte cadeau ;
  - le bouton indique le total, frais compris.
- **Billet** :
  - paiement repris avec choix de la carte et frais affichés (feuille du bas) ;
  - acompte après l'acceptation de l'organisateur ;
  - lignes carte cadeau et frais ;
  - bouton **Reçu PDF**.
- **Cartes cadeaux** (Profil → Cartes cadeaux, ou « Offrir cette sortie » sur la fiche) :
  - mes cartes, offertes et reçues, avec le code, le solde et la validité ;
  - offrir un montant ou la sortie : destinataire, numéro pour le SMS, petit mot, carte de paiement et frais, puis page de paiement ;
  - la liste se met à jour au retour dans l'app.

## Tests
- 15 tests au vert, dont 3 nouveaux :
  - calcul des frais (2 tests) ;
  - offrir une carte cadeau : montant, destinataire, carte Edahabia et total frais compris.
- `flutter analyze` ne signale rien.
