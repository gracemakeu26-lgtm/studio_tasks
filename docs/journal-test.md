# Journal des test de studio_task

## La rubrique nominal

Quand je teste avec les seeds la liste des tâches et chaque détail s'affichent comme prévu

##  La rubrique limites

quand je crée en console une tâche au titre de 120 caractères, une tâche à l'échéance très lointaine (ex. dans 10 ans), et quand je teste avec 0 tâche:
* Avec un titre de 120 caractère il deborde 
* Une échéance très lointaine reste lisile
* Avec 0 tâche l'état vide s'affiche 
* Avec une tâche sans échéance fait planté le logiciel
* défaut ouvert : l'application accepte une tâche sans titre

## La rubrique négatif

* **Pour /tasks/999** On obtient une erreur   
  Erreur de routage : Aucun itinéraire ne correspond à [GET] "/tasks/tasks/999"
* **Pour /tasks/abc** On obtinet une erreur
  ActiveRecord::RecordNotFound dans TasksController#show : Impossible de trouver la tâche avec l'identifiant « abc ».
* Ce qu'une utilisatrice verrait c'est Impossible de trouver la tâche avec l'identifiant « abc »(999).

##  La rubrique critique d'écran

la tâche principale de la gérante sur cette liste est de consulter les tâches; ce qui la sert : les titres des taches avec les priorit"s et les échéances; ce qui la gêne ou manque : il manque c'est la personne qui va réaliser la tâche

## Une amélioration augmentée est que le titre doit être court pas plus de 50 caractère