# Journal des test de studio_task

## La rubrique nominal

Quand je teste avec les seeds je m'attend à voir la liste des tâches ce que j'obtient : la liste des tâches et chaque détail s'affichent comme prévu donc auncune erreur : OK

##  La rubrique limites

quand je crée en console une tâche au titre de 120 caractères, une tâche à l'échéance très lointaine (ex. dans 10 ans), et quand je teste avec 0 tâche:
* Avec un titre de 120 caractère il deborde 
* Une échéance très lointaine reste lisile
* Avec 0 tâche l'état vide s'affiche 
* défaut ouvert : l'application accepte une tâche sans titre

## La rubrique négatif

* **Pour /tasks/999** On obtient une erreur   
  ActiveRecord::RecordNotFound dans TasksController#show
Impossible de trouver la tâche avec l'identifiant « 999 »
* **Pour /tasks/abc** On obtinet une erreur
  ActiveRecord::RecordNotFound dans TasksController#show : Impossible de trouver la tâche avec l'identifiant « abc ».
* Ce qu'une utilisatrice verrait c'est Impossible de trouver la tâche avec l'identifiant « abc »(999).

La difference avec le jour 3 est que le jour 3 l'action du controlleur show existait mais la vue show.html.erb n'existait pas encore maintenant la vue show.html.erb existe et aucune tâche dans la base de données n'as l'id 999

##  La rubrique critique d'écran

la tâche principale de la gérante sur cette liste est de consulter les tâches; ce qui la sert : les titres des taches avec les priorités et les échéances; ce qui la gêne ou manque : il manque c'est la personne qui va réaliser la tâche et ce qui la gène c'est sur le retard 

## Une amélioration augmentée est que le titre doit être court pas plus de 50 caractère parce que un long titre deborde de l'écran il est préférable d'utiliser un titre court et une déscription