# Lot 2 · Étape 3 — Réserver, billets hors connexion et mode scan dans l'app

Date : 3 novembre 2026

## Ce qui est fait
- **Fiche sortie** : barre du bas « À partir de … · Réserver » (ou « Complet · liste d'attente »), séances complètes signalées.
- **Réserver** :
  - séances avec places restantes, liste d'attente (s'inscrire, quitter, place proposée) ;
  - billets (+ / −) dans la limite des places et du maximum par personne ;
  - point de ramassage, options payantes, noms des participants (billets nominatifs) ;
  - billet en ligne ou réservation simple (paiement sur place, acompte, CCP), message à l'organisateur ;
  - total et acompte, puis paiement dans le navigateur de l'app, et billet ;
  - lien de groupe partagé avec la feuille du téléphone.
- **Mes billets** : à venir et passés ; chaque billet avec son QR code, statut, heure du scan, transfert (numéro ou lien partagé), annulation selon la règle, ajout au calendrier, itinéraire, appel de l'organisateur ; payer une réservation bloquée ou une place de la liste d'attente.
- **Hors connexion** : les billets sont gardés sur le téléphone ; sans réseau, l'app affiche la copie avec un bandeau. Effacés à la déconnexion et à la suppression du compte.
- **Mode scan** (Profil → Mode scan) :
  - séances du jour et des 7 prochains jours ;
  - liste des billets téléchargée ; scan par la caméra ou code saisi ;
  - vert (valide, avec le nom et le point de ramassage), orange (déjà utilisé, avec l'heure), rouge (inconnu ou annulé) ;
  - compteur d'entrées, scans gardés et envoyés dès que le réseau revient, statuts des autres appareils récupérés.
- Backend : la synchronisation accepte une liste vide (mise à jour des statuts seule).

## Tests
- 12 tests au vert (3 nouveaux) : réserver une inscription gratuite jusqu'au billet avec QR codes ; Mes billets sans réseau depuis la copie ; mode scan vert, orange, rouge et envoi des scans.
- Vérifié sur la version web à 390 px contre le backend local : Mes billets (Amina), billet en attente avec acompte, écran Réserver, mode scan de Nadia (3 / 23 entrées).
- `flutter analyze` ne signale rien.

## À vérifier de ton côté (à la fin)
- Sur un vrai téléphone : scanner le QR d'un billet affiché sur le site avec le compte « Équipe d'accueil », couper le réseau, scanner encore, puis remettre le réseau.
