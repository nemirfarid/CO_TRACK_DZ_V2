# CO TRACK DZ — base V2 reconstruite

Application Flutter Android hors ligne : comptes locaux par appareil, SQLite, scan de référence client/PDL et codes des deux détecteurs, GPS, historique et export XLSX.

## Limites importantes
- L'identifiant d'entreprise est unique uniquement dans la base locale de ce téléphone. Sans serveur, aucune unicité mondiale ni synchronisation multi-appareils n'est possible.
- Les mots de passe sont salés et hachés localement. Le mot de passe est dérivé avec PBKDF2-HMAC-SHA256 (120 000 itérations) et un sel aléatoire propre au compte.
- La base préserve les anciennes colonnes photo lors d'une migration de version 1 ; l'interface V2 ne capture, ne lit et n'exporte aucune photo.
- Les exports sont enregistrés dans le répertoire externe privé de l'application. Vérifier l'accès/partage sur les téléphones cibles.
- Le scan PDL recherche un seul candidat de format 27... ; valider le format des factures anonymisées Sonelgaz avant exploitation.
- Les contraintes d'unicité PDL/détecteurs sont globales dans la base historique, comme dans la version de départ.

## Build
GitHub Actions → Build CO TRACK DZ APK. Le workflow génère les fichiers Android manquants, analyse et construit l'APK release.
