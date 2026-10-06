# Journal des test de studio_task

## La rubrique nominal

Quand je teste avec les seeds je m'attend à voir la liste des tâches ce que j'obtient : la liste des tâches et chaque détail s'affichent comme prévu donc auncune erreur : OK

## La rubrique limites

quand je crée en console une tâche au titre de 120 caractères, une tâche à l'échéance très lointaine (ex. dans 10 ans), et quand je teste avec 0 tâche:

- Avec un titre de 120 caractère il deborde
- Une échéance très lointaine reste lisile
- Avec 0 tâche l'état vide s'affiche
- défaut ouvert : l'application accepte une tâche sans titre

## La rubrique négatif

- **Pour /tasks/999** On obtient une erreur  
   ActiveRecord::RecordNotFound dans TasksController#show
  Impossible de trouver la tâche avec l'identifiant « 999 »
- **Pour /tasks/abc** On obtinet une erreur
  ActiveRecord::RecordNotFound dans TasksController#show : Impossible de trouver la tâche avec l'identifiant « abc ».
- Ce qu'une utilisatrice verrait c'est Impossible de trouver la tâche avec l'identifiant « abc »(999).

La difference avec le jour 3 est que le jour 3 l'action du controlleur show existait mais la vue show.html.erb n'existait pas encore maintenant la vue show.html.erb existe et aucune tâche dans la base de données n'as l'id 999

## La rubrique critique d'écran

la tâche principale de la gérante sur cette liste est de consulter les tâches; ce qui la sert : les titres des taches avec les priorités et les échéances; ce qui la gêne ou manque : il manque c'est la personne qui va réaliser la tâche et ce qui la gène c'est sur le retard

## Une amélioration augmentée est que le titre doit être court pas plus de 50 caractère parce que un long titre deborde de l'écran il est préférable d'utiliser un titre court et une déscription

Le défaut ouvert est fermé le 02/10/1026 avec les preuves suivantes:

- Task.create(title: "") retourne une erreur : ["Title can't be blank"]

## Test du formulaire cas / attendu / obtenu / verdict

- **formulaire entièrement vide** affiche les erreurs et le formulaire vide / erreurs + formulaire vide/ Correct
- **titre de 121 caractères** Erreur / Erreur : Title is too long (maximum is 120 characters)/ Correct
- **titre de exactement 120 caractères** Accepté / Accepté : Tâche créée avec succès :) / Correct
- **priorité forgée à 9 avec les DevTools** Erreur / Erreur : Priority is not included in the list / Correct
- **double-clic rapide sur le bouton d'envoi** Erreur / erreur + formulaire vide / Correct
- **seul le titre rempli, champs optionnels vides** Accepté / Accepté / Correct

## Test du CRUD

- **Creer** OK
- **Lire** OK
- **Modifier** OK
- **Marquer fait** La tâche passe à fait mais passe d'abord par les détails de la tâche. Acceptable
- **Supprimer** OK

Étant donné deux onglets ouverts sur la même tâche, quand je la supprime dans l'un puis tente de la modifier dans l'autre, une erreur survient : **ActiveRecord::RecordNotFound in TasksController#show : Couldn't find Task with 'id'="153"**. C'est pas très grave car lorsque on supprime ça supprime aussi dans la base de donnée d'où l'erreur

Étant donné l'URL /tasks/999/edit (tâche inexistante), quand je l'ouvre, alors une erreur s'affiche : **ActiveRecord::RecordNotFound dans TasksController#show Impossible de trouver la tâche avec l'identifiant « 999 ».** Gravité Majeure	L'utilisateur final fait face à une page technique au lieu d'une page d'erreur 404 propre et stylisée, ce qui nuit à l'expérience et peut exposer des données sur la structure du code.

• annulation : « Annuler » (annule la modification et revient à l'état précédent).
• Bouton de validation : « Modifier la tâche » / « Mettre à jour la tâche » (soumet définitivement le formulaire)

## Jour 9

### La session de test : la réceptionniste. 

Créer une tâche, chronomètrer le temps et compter le nombre de click 

- **Appeler une cliente : Titre, échéance, priorité** 2 clics en 25s.
- **livraison à relancer : Titre, échéance, priorité, description** 2 clics en 49s
- **tâche terminée à cocher :** 2 clics en 10s

### Problème détecté quand on fait passer une tâche non faite à faite : aucun flash et normalement les détails de la tâche ne doivent pas se voir lors de passage mais ça se voit.

### Pour l'objectif des trois clics, 
- j'ai pas plus de trois clics pour créer une tâche c'est tenu, creer un tache(prémier clic) -> remplir le formulaire -> soummettre(deuxième clic)
- pour supprimer j'ai besoin de 3 clics c'est tenu, clic sur la tâche(prémier clic) ->  clic supprimer (deuxième clic) -> ok(troisième clic)
- par contre pour modifier j'ai besoin de 4 clics c'est pas tenu, clic sur la tâche(prémier clic) ->  clic modifier (deuxième clic)-> remplir le formulaire -> Enregistrer les modifications(troisième clic) -> retour à la liste. le click en trop se perd pour quitter des détails après la modification pour la liste des tâches


### La session de test : la gérante.

- Étant donné la liste, quand je cherche ce qui est en retard, ce qui est important et ce qui est fait, alors ça me prend 20s pour trouver ce qui est en retard, ce qui est fait.
### Les difficultés
- Difficulté au niveau de la distinction entre les tâches faites et non faites -> défaut d'écran
- Pour voir une importance il faut ouvrir la page des détails alors que c'est mieux quand c'est visible sur la liste -> défaut d'écran
- Les tâche faites ont encore un bouton fait -> manque structurel
- Voir les responsables des tâches : Pour la semaine prochaine