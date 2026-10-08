# Journal des test de studio_task

## ## La rubrique nominal
Quand je teste avec les seeds je m'attend à voir la liste des tâches ce que j'obtient : 
* la liste des tâches et chaque détail s'affichent comme prévu donc auncune erreur : **OK**

## ## La rubrique limites
quand je crée en console une tâche au titre de 120 caractères, une tâche à l'échéance très lointaine (ex. dans 10 ans), et quand je teste avec 0 tâche:
* **Avec un titre de 120 caractère :** il deborde
* **Une échéance très lointaine :** reste lisile
* **Avec 0 tâche :** l'état vide s'affiche
* **défaut ouvert :** l'application accepte une tâche sans titre

## ## La rubrique négatif
* **Pour /tasks/999 :** On obtient une erreur `ActiveRecord::RecordNotFound` dans `TasksController#show` : *Impossible de trouver la tâche avec l'identifiant « 999 »*
* **Pour /tasks/abc :** On obtinet une erreur `ActiveRecord::RecordNotFound` dans `TasksController#show` : *Impossible de trouver la tâche avec l'identifiant « abc »*.
* **Ce qu'une utilisatrice verrait :** c'est *Impossible de trouver la tâche avec l'identifiant « abc »(999)*. 

La difference avec le jour 3 est que le jour 3 l'action du controlleur show existait mais la vue `show.html.erb` n'existait pas encore maintenant la vue `show.html.erb` existe et aucune tâche dans la base de données n'as l'id 999.

## ## La rubrique critique d'écran
la tâche principale de la gérante sur cette liste est de consulter les tâches; 
* **ce qui la sert :** les titres des taches avec les priorités et les échéances; 
* **ce qui la gêne ou manque :** il manque c'est la personne qui va réaliser la tâche et ce qui la gène c'est sur le retard

## Une amélioration augmentée
est que le titre doit être court pas plus de 50 caractère parce que un long titre deborde de l'écran il est préférable d'utiliser un titre court et une déscription.

Le défaut ouvert est fermé le 02/10/1026 avec les preuves suivantes:
* `Task.create(title: "")` retourne une erreur : `["Title can't be blank"]`

## ## Test du formulaire
**cas / attendu / obtenu / verdict**
* **formulaire entièrement vide :** affiche les erreurs et le formulaire vide / erreurs + formulaire vide / **Correct**
* **titre de 121 caractères :** Erreur / Erreur : *Title is too long (maximum is 120 characters)* / **Correct**
* **titre de exactement 120 caractères :** Accepté / Accepté : *Tâche créée avec succès :)* / **Correct**
* **priorité forgée à 9 avec les DevTools :** Erreur / Erreur : *Priority is not included in the list* / **Correct**
* **double-clic rapide sur le bouton d'envoi :** Erreur / erreur + formulaire vide / **Correct**
* **seul le titre rempli, champs optionnels vides :** Accepté / Accepté / **Correct**

## ## Test du CRUD
* **Creer :** OK
* **Lire :** OK
* **Modifier :** OK
* **Marquer fait :** La tâche passe à fait mais passe d'abord par les détails de la tâche. **Acceptable**
* **Supprimer :** OK
* **titre vidé sur edit :** Apparition de l'erreur

Étant donné deux onglets ouverts sur la même tâche, quand je la supprime dans l'un puis tente de la modifier dans l'autre, une erreur survient : **ActiveRecord::RecordNotFound in TasksController#show : Couldn't find Task with 'id'="153"**. C'est pas très grave car lorsque on supprime ça supprime aussi dans la base de donnée d'où l'erreur.

Étant donné l'URL `/tasks/999/edit` (tâche inexistante), quand je l'ouvre, alors une erreur s'affiche : **ActiveRecord::RecordNotFound dans TasksController#edit Impossible de trouver la tâche avec l'identifiant « 999 ».**

**Source extraite (vers la ligne 44 ) :**
```ruby
def set_task
  @task = Task.find(params[:id])
end
```

Vu que le `Task.find` vit dans `set_task`, `set_task` gère 4 actions (show, edit, update, delete) donc chaque fois qu'il y aura erreur de type **impossible de trouver la tâche avec l'identifiant «...»** c'est `set_task` qui lève l'erreur pour les 4 actions donc aussi pour update et delete. 

* **Gravité Majeure :** L'utilisateur final fait face à une page technique au lieu d'une page d'erreur 404 propre et stylisée, ce qui nuit à l'expérience et peut exposer des données sur la structure du code.
* **annulation :** « Annuler » (annule la modification et revient à l'état précédent).
* **Bouton de validation :** « Modifier la tâche » / « Mettre à jour la tâche » (soumet définitivement le formulaire)

## ## Section 06/10/2026

### ### La session de test : la réceptionniste.
Créer une tâche, chronomètrer le temps et compter le nombre de click :
* **Appeler une cliente : Titre, échéance, priorité :** 2 clics en 25s.
* **livraison à relancer : Titre, échéance, priorité, description :** 2 clics en 49s
* **tâche terminée à cocher :** 2 clics en 10s

### ### Problème détecté
quand on fait passer une tâche non faite à faite : aucun flash et normalement les détails de la tâche ne doivent pas se voir lors de passage mais ça se voit.

### ### Pour l'objectif des trois clics,
* **pour créer une tâche :** j'ai pas plus de trois clics c'est tenu. *creer un tache (prémier clic) -> remplir le formulaire -> soummettre (deuxième clic)*
* **pour supprimer :** j'ai besoin de 3 clics c'est tenu. *clic sur la tâche (prémier clic) -> clic supprimer (deuxième clic) -> ok (troisième clic)*
* **pour modifier :** par contre j'ai besoin de 4 clics c'est pas tenu. *clic sur la tâche (prémier clic) -> clic modifier (deuxième clic) -> remplir le formulaire -> Enregistrer les modifications (troisième clic) -> retour à la liste.* Le click en trop se perd pour quitter des détails après la modification pour la liste des tâches.

### ### La session de test : la gérante.
* Étant donné la liste, quand je cherche ce qui est en retard, ce qui est important et ce qui est fait, alors ça me prend **20s** pour trouver ce qui est en retard, ce qui est fait.

### ### Les difficultés
* Difficulté au niveau de la distinction entre les tâches faites et non faites -> **défaut d'écran OUI**
* Pour voir une importance il faut ouvrir la page des détails alors que c'est mieux quand c'est visible sur la liste -> **défaut d'écran OUI**
* Les tâche faites ont encore un bouton fait -> **défaut d'écran OUI**
* Voir les responsables des tâches -> **manque structurel (manque le lien de la tâche à la responsable) NON**

### ### Défaut d'écran
voir l'importance sur la liste pour la gérante afin que quand elle voit la liste elle voit les taches, leurs importances, leurs échéances, faite ou non.

Après correction la gérante prend **16s** pour trouver ce qui est iportant, ce qui est en retart, et ce qui est fait.

## ## Section 08/10/2026

### Rembourser la dette : gérer une tâche introuvable dans set_task

- Etant donné le défaut ouvert avec l'UEL /tasks/999 quand je l'ouvre alors il apparait un flash qui dit : Cette tâche n'existe pas ou a été supprimée. Donc le défaut est férmé
- Étant donné deux onglets, quand je supprime la tâche dans l'un puis l'enregistre dans l'autre, alors je vois ce même comportement. Défaut férmé

### Mener la campagne de test n°2 (15 cas au moins, par rôle, avec gravités)

#### Réceptionniste : son workflow Elle ouvre l'appli → Elle crée rapidement une tâche. → Elle ajoute les détails et le niveau d’urgence. → l'assigne → Elle suit son état : à faire, en cours ou terminée.→ est notifiée quand c'est fait

#### Cas 1
Créer une  tâche → Tâche créée et classée selon la date et la priorité → Tâche crée classée selon la date mais pas selon la priorité → Tolérable

#### Cas 2
Modifier une  tâche → Tâche modifiée et classée selon la date et la priorité → Tâche modifiée classée selon la date mais pas selon la priorité → Tolérable

#### Cas 3
Supprimer une  tâche → Tâche supprimée → Tâche supprimée → Correct

#### Cas 4
Titre vide → Tâche non créée → Tâche non créée : erreur  → Correct

#### Gérante : son workflow Elle ouvre l'appli → voit les tâches en retard en premier → crée une tâche → l'assigne → est notifiée quand c'est fait

#### Cas 5
Titre trop long → Tâche non créée → Tâche non créée : erreur → Correct

#### Cas 6
Priorité forgée → Tâche non créée → Tâche non créée : erreur → Correct

#### Cas 7
Double soumission → Tâche créée à la prémière soumission erreur à la deuxième → Tâche créée à la prémière soumission erreur à la deuxième → Correct

#### Cas 8
Onglets concurrents → Prémier onglet réagit sans erreur, deuxième onglet génère une erreur → Prémier onglet réagit sans erreur, deuxième onglet génère une erreur → Correct

#### Cas 9
Ids inexistant → Erreur et retour sur la liste des tâches → Erreur et retour sur la liste des tâches → Correct

#### Cas 10
Navigation clavier → Remplir le formulaire et créer la tâche → Tâche créée → Correct

#### Cas 11
Test avec l'url /tasks/abc → Retour sur la liste avec un flash → Retour sur la liste avec un flash → Correct

#### Cas 12
Message trop long → Tâche non créée : erreur  → Tâche non créée : erreur → Correct

#### Cas 13
Modification avec titre vide → Tâche non créée : erreur  → Tâche non créée : erreur → Correct

#### Cas 14
Échéance vide → Tâche créée → Tâche non créée → Correct

#### Cas 15
Message trop long → Tâche non créée : erreur  → Tâche non créée : erreur → Correct

### Synthèse

D'après cette campagne, ce qui marche c'est la création d'une tâche, la modification d'une tâche, la suppression d'une tâche, la navigation au clavier pour remplir le formulaire et entré pour soumettre. Pour le rôle de l'esthéticienne il faut assiger les tâches qui est un manque structurel (à compléter la semaine prochaine). Pour un défaut ouvert c'est le fait que les tâches soient classées seulement par ordre de date alors qu'elles doivent être par ordre de date et de priorité



