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
Réceptionniste -> Créer une  tâche → Tâche créée et classée selon la date et la priorité → Tâche crée classée selon la date mais pas selon la priorité → Tolérable Gravité mineur

#### Cas 2
Réceptionniste -> Modifier une  tâche → Tâche modifiée et classée selon la date et la priorité → Tâche modifiée classée selon la date mais pas selon la priorité → Tolérable Gravité mineur

#### Cas 3
Réceptionniste -> Supprimer une  tâche → Tâche supprimée → Tâche supprimée → Correct

#### Cas 4
Réceptionniste -> Titre vide → Tâche non créée → Tâche non créée : erreur  → Correct

#### Gérante : son workflow Elle ouvre l'appli → voit les tâches en retard en premier → crée une tâche → l'assigne → est notifiée quand c'est fait

#### Cas 5
Gérante -> Titre trop long → Tâche non créée → Tâche non créée : erreur → Correct

#### Cas 6
Gérante -> Priorité forgée → Tâche non créée → Tâche non créée : erreur → Correct

#### Cas 7
Gérante -> Double soumission → Tâche créée à la prémière soumission erreur à la deuxième → Tâche créée à la prémière soumission erreur à la deuxième → Correct

#### Cas 8
Gérante -> Onglets concurrents → Prémier onglet réagit sans erreur, deuxième onglet génère une erreur → Prémier onglet réagit sans erreur, deuxième onglet génère une erreur → Correct

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
Échéance vide → Tâche créée → Tâche créée → Correct

#### Cas 15
Tâche sans message → Tâche créée → Tâche créée → Correct

### Synthèse

D'après cette campagne, ce qui marche c'est la création d'une tâche, la modification d'une tâche, la suppression d'une tâche, la navigation au clavier pour remplir le formulaire et entré pour soumettre. Pour le rôle de l'esthéticienne il faut assiger les tâches qui est un manque structurel (à compléter la semaine prochaine). Pour un défaut ouvert c'est le fait que les tâches soient classées seulement par ordre de date alors qu'elles doivent être par ordre de date et de priorité

Après l'ajout de Task.order(... priority: :desc) dans le controller, quand je rejoue encore le cas 1 et 2 les tâches s'affichent par date et priorié


## ## Section du 12/10/2026

- **Mauvais mot de passe** Message d'erreur : Try another email address or password.
- **Email inexistant** Message d'erreur : Try another email address or password. 
- **Email correct avec casse changé** Accès aux tâches 
- Le message d'échec pour le mauvais mot de passe et l'email incorrect c'est pour que si un attaquant tente de se connecter qu'il ne sache pas réellement où il a fait l'erreur lors de la connexion
- Ce qui normalise l'email c'est app/models/user.rb ligne 5

## ## Section du 19/10/2026

### Test du workflow de l'esthéticienne 

- connexion → mes tâches → cocher Fait : 30s
- Un constat est que l'esthéticienne peut modifier une tâche c'est un manque structurel (autorisation n'existe pas encore)
- Un constat est que l'esthéticienne peut supprimer une tâche c'est un manque structurel (autorisation n'existe pas encore)
- L'atterrissage après connexion, elle arrive sur TOUTES les tâches au lieu des siennes, c'est un manque structurel (c'est de l'autorisation d'affichage).

## ## Section du 29/10/2026

| URL               | Refus               | Message               | Redirection               |
|-----              |-------              |---------              |-------------              |
|esthéticienne : /tasks/34/edit    | Oui | Tu ne peux modifier que tes tâches.| Toutes les tâches|
|suppression forgée via button_to recréé dans les DevTools | OUi | Action réservée à la gérante.| Toutes les tâches|
|?mine=1 trafiqué | Oui | | Toutes les tâches|
|réceptionniste : /tasks/37/edit | Oui | Tu ne peux modifier que tes tâches.| Toutes les tâches|
|déconnectée : toutes les URLs | Oui|   | Page de connection |


## ## Section du 30/10/2026


### Workflows croisés
- La gérante crée une tâche et l'assigne à l'esthéticienne en 24s
- L'esthéticenne la trouve et la coche en 11s
- La gérante recharge et la constate en 9s

### Campagne N°3

#### Chapitre Gerante

- Gérante : crée une tâche -> assigne -> modifie -> supprime . Tâche créée, modifiée et supprimée . Tâche créée, modifiée et supprimée . OK
- Gérante : Se connecte -> voit toutes les tâches .  Connecté : toutes les tâches . Connecté : toutes les tâches . OK
- Gérante : cocher toutes les tâches . Tache modifiée . Tâche modifiée . OK

#### Chapitre Esthéticienne

- Esthéticienne : crée une tâche -> modifie les siennes -> coche les siennes . Tâche créée, modifiée et cochée . Tâche créée, modifiée et supprimée . OK
- Esthéticienne : Se connecte -> voit ses tâches .  Connecté : toutes ses tâches . Connecté : toutes ses tâches . OK
- Esthéticienne : Modifier un tâche qui n'est pas la sienne . "Tu ne peut modifier que tes tâches" . Tu ne peux modifier que tes tâches . OK 

#### Chapitre Receptionniste

- Receptionniste : crée une tâche -> voit les détails -> Coche les siennes . Tâche créée, et cochée . Tâche créée, et cochée . OK
- Receptionniste : Se connecte -> voit toutes les tâches . Connecté : toutes les tâches . Connecté : toutes les tâches . OK 
- Receptionniste : cocher une tâche qui n'est pas la sienne . "Tu ne peut modifier que tes tâches" . Tu ne peux modifier que tes tâches . OK 

#### Chapitre sécurité

- esthéticienne : /tasks/X/edit d'une tâche d'une collègue . Refus . Refus . OK
- suppression forgée (recrée le button_to delete dans les DevTools) . refus . refus . OK
- ?mine=1 trafiqué . retour à la liste des tâches . retour à la liste des tâches . OK
- Connectée en réceptionniste : /tasks/X/edit de n'importe quoi . refus . refus . OK
- Déconnectée : toutes les URLs . retour à la page de connection . retour à la page de connection . OK

#### Chapitre limites

- double session du même compte . OK
- déconnexion dans une fenêtre puis action dans l'autre . Action se voit après la connection dans la fenêtre déconnecté . Action se voit après la connection dans la fenêtre déconnecté . OK
- cookie supprimé en pleine navigation . Déconnexion . DEconnecxion . OK 
- retour arrière après déconnexion . Parge de connexion . Page de connexion . OK

#### Synthèse

Cette campagne N°3 permet de vise à tester chaque utilisateur avec son workflow, la sécurité et les limites. Chaque utilisateur à 3 cas, la sécurité à 5 cas et les limtites ont 4 cas pour un total de 18 cas. Le cas du chapitre limite qui m'a surprise est le retour en arrière après la déconnexion, ça consiste  à se deconnecter et cliquer sur le bouton revenir en arrière du navigateur. Ça ramère toujour sur la page de connection.

### Critiquer la liste des tâches 

- La gérante ne voit pas qui est surchargée car quand elle arrive elle voit les tâches en retard, les priorité, et les responsables mais elle ne connait pas qui est surchargée. Je propose que quand elle se connecte elle voit aussi le nombre total des tâches et aussi le nombre de tâche par utilisateur. Son cout estimé est grosse et c'est un défaut d'écran.
- Trop d'information pour la receptionniste (la colonne responsable) elle peut juste cliquer sur mes tâche pour voir ses tâches. Je propose que elle voit toutes les tâches mais pas les responsables. Sonn cout est estimé est petite et c'est un défaut d'écran.
- Puisque l'estheticienne et la receptionniste ne peuvent cocher que le tâche, ce n'est pas nécessaire d'avoir un bouton terminé sur les tâches qui ne leur appartiennent pas, je propose de retirer ce bouton sur ces tâches. cout moyen , défaut d'écran

## Campagne n°4 — 11/11/2026 — protocole machine puis humain

### Partie machine

- Revue complète de `app/` et `test/` : le bouton « Terminer » apparaît sur des
  tâches que certains rôles ne peuvent pas terminer; la création par une
  non-gérante affiche un responsable mais enregistre une tâche non assignée;
  les dates de filtre utilisent `Date.today` tandis que l'écran utilise
  `Date.current`.
- La suite complète `bin/rails db:test:prepare test` est verte : **49 tests,
  228 assertions, 0 échec, 0 erreur, 0 ignoré**, en 3,25 s; couverture lignes
  **164/173 (94,79 %)**.
- La suite ciblée des rôles et workflows est verte : **23 tests, 139
  assertions**, en 4,89 s.
- Le vrai scénario « deux onglets » est désormais une régression d'intégration :
  formulaire chargé, suppression, PATCH périmé, redirection et alerte vérifiés.
- Contrôles complémentaires : Importmap réussi; RuboCop en échec sur des
  infractions de style préexistantes; Brakeman termine avec le code 5 et indique
  que 8.0.6 est en retard sur 8.1.0, sans afficher de rapport; Bundler Audit
  signale des avis sur les dépendances.
  `test:system` est indisponible faute de `test/system/`. La suite Rails est
  verte, pas l'ensemble des contrôles CI.

### Partie humaine — uniquement ce que la machine ne voit pas

**Session de rôle — réceptionniste.** La session interactive locale,
chronométrée de l'ouverture du formulaire jusqu'au constat des compteurs après
les deux créations, a duré **1 min 57 s**. La création reste à **2 clics**
(« Nouvelle tâche », puis « Enregistrer »), comme en semaine 2 : le score des
3 clics n'a pas bougé; l'objectif est toujours tenu.

Le parcours a commencé sur « Toutes les tâches », puis la réceptionniste a créé
une tâche ouverte échéant aujourd'hui. « Tâches du jour » est passé de 0 à 1,
mais « Non assignées » a également augmenté et « Mes tâches » n'a pas bougé :
le formulaire montrait la réceptionniste comme responsable, mais la tâche créée ne lui est
pas attribuée. Le suivi de sa propre création n'est donc pas terminé.

**Critique de l'écran touché — compteur `due_today`.** Il est placé dans le
groupe de compteurs/filtres en haut de la liste : emplacement visible et
cohérent pour trier la journée. Il est utile à la gérante et à la réception
pour repérer la charge du jour; pour l'esthéticienne, un total global ne dit pas
combien de tâches lui reviennent. Le libellé ne précise pas non plus que le
compteur exclut les tâches terminées. La création observée révèle en outre
qu'un compteur global peut augmenter alors que la tâche reste absente de
« Mes tâches ».

| Cas de la litanie `due_today` | Résultat observé |
|---|---|
| Frontière de fuseau horaire | Non reproduite : l'hôte et Rails étaient tous deux en UTC et indiquaient le 11/11/2026. La revue a toutefois trouvé `Date.today` dans le scope contre `Date.current` dans l'écran; un changement de date entre ces horloges reste à tester. |
| Tâche due aujourd'hui déjà terminée | Créée via le formulaire avec « Terminée » cochée : le compteur est resté à 1. Comportement attendu observé; aucun test automatisé ne couvre ce cas précis. |
| Tâche créée aujourd'hui pour aujourd'hui | Créée ouverte via le formulaire : le compteur est passé de 0 à 1. Cas observé; la tâche est restée non assignée, défaut de workflow distinct. |

### Synthèse côte à côte

| Campagne | Couverture | Temps humain |
|---|---|---:|
| n°3 | 18 cas manuels | 45 min |
| n°4 | 49 tests machine + 3 cas humains `due_today` (le parcours réceptionniste est inclus dans le troisième) + critique d'écran | 1 min 57 s |

La manipulation humaine chronométrée est plus courte; la suite machine a pris
en charge les vérifications répétables. Le temps est celui de cette session
interactive locale, pas une étude avec une participante externe; la frontière
de fuseau n'a pas été forcée.

## Bilan de phase — What our test suite would have caught in my Week-1 JavaScript projects

1. The “donne” button was a broken user action; an integration test would have caught it.
2. The integration test should assert the click's visible result, not merely that the button exists.
3. “SILVERS” was a wrong domain value; a model test for valid values would have caught it.
4. A boundary-focused model test would have made that value failure precise and repeatable.
5. The widget-shadowing bug changed the rendered workflow; an integration test would have exposed it.
6. That integration test should exercise the widget through the user's real screen, not a mock alone.
7. The failure at assertion 146 needed a regression test that reproduced its incorrect result.
8. The regression test would keep that historical failure from returning after a fix.
9. Model tests protect domain rules; integration tests protect complete user workflows.
10. Together, model, integration, and regression tests close the loop between both training programs.