# Liste des dettes

## Fermées cette semaine

- [x] Le scénario des deux onglets est maintenant couvert : charger le formulaire
  d'édition, supprimer la tâche dans l'autre onglet, puis envoyer le PATCH
  périmé. La régression vérifie la redirection, le message exact et l'absence
  de mutation dans `test/integration/tasks_crud_integration_test.rb`
  (`a stale edit from another tab is handled after task deletion`).
- [x] Le README indiquait qu'une réceptionniste pouvait modifier sa propre
  tâche par URL, contrairement au contrôleur et au test
  `test/controllers/tasks_controller_test.rb`. Le tableau des droits du README
  reflète maintenant le refus réel.

## Comptes et droits

- Provisionnement des comptes absent de l’interface → définir qui crée les comptes et comment les identifiants sont remis aux nouveaux membres.
- Aucun rôle par défaut et rôles codés en dur dans `User` → choisir le rôle d’un nouvel employé explicitement et prévoir comment gérer les nouveaux rôles.
- Les tâches créées par une esthéticienne ou une réceptionniste restent non assignées, même si le formulaire affiche leur nom comme responsable → décider si elles doivent être attribuées automatiquement à leur créatrice et aligner la confirmation affichée.
- Le bouton « Terminer » est affiché sur des tâches que l'esthéticienne ou la réceptionniste n'a pas le droit de terminer → masquer le contrôle lorsque l'action sera refusée côté serveur.

## Dates et couverture de l'interface

- Le compteur `due_today` utilise `Date.today` tandis que l'affichage des dates utilise `Date.current` → couvrir une frontière de fuseau horaire et utiliser une même date métier.
- Aucun test automatisé ne vérifie une tâche déjà terminée dont l'échéance est aujourd'hui; le test de modèle actuel n'exclut qu'une tâche terminée en retard.
- Aucun system test ne vérifie l'interface elle-même. La commande CI `test:system` ne peut pas s'exécuter tant que `test/system/` et ses scénarios n'existent pas.
