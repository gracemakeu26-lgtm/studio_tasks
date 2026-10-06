# Journal

## L'installation

- **Ruby** ruby 3.4.10
- **Rails** Rails 8.1.3.1
- **which ruby** `/home/grace/.rvm/rubies/ruby-3.4.10/bin/ruby`

---

## Expédition dans le squelette

| Dossiers                                    | Action                                                                                                                                                                                                               |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `config/routes.rb`                          | Ce dossier/fichier contient la carte des URL (chemins) de l'application, j'y toucherai quand je devrai créer une nouvelle page accessible ou modifier l'adresse d'un lien.                                           |
| `Gemfile`                                   | Ce fichier contient la liste des bibliothèques externes (gems) requises, j'y toucherai quand je devrai installer un nouvel outil (comme un système d'authentification) ou mettre à jour une dépendance.              |
| `db/`                                       | Ce dossier contient les fichiers de configuration et de migration de la base de données, j'y toucherai quand je devrai créer une nouvelle table ou modifier un champ existant.                                       |
| `app/controllers/application_controller.rb` | Ce dossier contient la logique qui reçoit et traite les requêtes des utilisateurs, j'y toucherai quand je devrai récupérer des données pour les envoyer à une vue ou rediriger l'utilisateur.                        |
| `app/models/`                               | Ce dossier contient les données de l'application et leurs règles métiers, j'y toucherai quand je devrai créer un nouveau type d'objet ou ajouter des validations sur les données.                                    |
| `app/views/`                                | Ce dossier contient les templates HTML/ERB pour afficher l'interface, j'y toucherai quand je devrai modifier le design, ajouter du texte ou changer le visuel d'une page.                                            |
| `test/`                                     | Ce dossier contient les scripts de tests automatisés de l'application, j'y toucherai quand je devrai écrire des scénarios pour vérifier que mon code fonctionne correctement et éviter les bugs.                     |
| `public/`                                   | Ce dossier contient les fichiers statiques servis tels quels (pages d'erreur, robots.txt), j'y toucherai quand je devrai personnaliser la page d'erreur 404 ou ajouter des fichiers accessibles directement par URL. |

---

## Contrôle express en console

```ruby
task = { title: "Préparer la cabine", done: false }

task[:title]                # "Préparer la cabine"
task["title"]               # nil
[1, 2, 3].map { |n| n * 2 } # [1, 4, 6]
def price; 40; end
price                       # 40
```

---

## Rituel du soir (jour 1)

- **Pourquoi RVM plutôt qu'un Ruby système ?** Parce que RVM permet d'installer plusieurs versions de Ruby pour permettre de travailler sur des projets qui utilisent des versions différentes.
- **À quoi sert le `Gemfile.lock` ?** Il gère et fige les versions exactes de gem.
- **Et que veut dire convention over configuration — avec un exemple vu aujourd'hui ?** Rails décide de l'organisation à ma place. Un exemple : `rails new` génère le squelette complet d'une application.

---

## Tracé papier de `GET /tasks/1` et les erreurs `/machin`, `/tasks/new`, `/tasks/999`

### Tracé papier des routes

| Prefix      | Verb   | URI Pattern                 | Controller#Action |
| ----------- | ------ | --------------------------- | ----------------- |
| `tasks`     | GET    | `/tasks(.:format)`          | `tasks#index`     |
|             | POST   | `/tasks(.:format)`          | `tasks#create`    |
| `new_task`  | GET    | `/tasks/new(.:format)`      | `tasks#new`       |
| `edit_task` | GET    | `/tasks/:id/edit(.:format)` | `tasks#edit`      |
| `task`      | GET    | `/tasks/:id(.:format)`      | `tasks#show`      |
|             | PATCH  | `/tasks/:id(.:format)`      | `tasks#update`    |
|             | PUT    | `/tasks/:id(.:format)`      | `tasks#update`    |
|             | DELETE | `/tasks/:id(.:format)`      | `tasks#destroy`   |
| `root`      | GET    | `/`                         | `tasks#index`     |

### Tracé papier de `GET /tasks/1`

```
GET tasks/1 ==> config/routes.rb ==> app/controllers/tasks_controller.rb
==> app/models/task.rb ==> app/views/tasks/show.html.erb ==> HTML (navigateur)
```

Le numéro `1` va dans l'objet `params[:id]` du contrôleur, ce qui permet de l'utiliser pour envoyer une requête à la base de données.

### Les erreurs `/machin`, `/tasks/new`, `/tasks/999`

- **`/machin`** : aucune route ne correspond à `/machin` dans `config/routes.rb`.
- **`/tasks/new`** : la route `/tasks/new` existe mais l'action `new` du contrôleur n'existe pas.
- **`/tasks/999`** : la route `/tasks/999` existe et l'action `show` du contrôleur existe.

---

### Les 3 requêtes de la gérante et la décision « une tâche faite est-elle en retard ? »

- **Les tâches non faites, les plus urgentes d'abord ?**

  ```ruby
  Task.where(done: false).order(:due_on)
  ```

- **Combien de tâches en retard ?**

  ```ruby
  Task.where(done: false).where("due_on < ?", Date.today).count
  ```

- **La tâche n°2, marque-la faite :**
  ```ruby
  task = Task.find(2)
  task.done = true
  task.save
  ```

---

## `Task.create(title: nil)`, `Task.create(title: "")`, `Task.find(999)`

- **`Task.create(title: nil)`** : la contrainte empêche de créer un titre `nil`.
- **`Task.create(title: "")`** : la contrainte empêche de créer un titre `nil` mais pas un titre vide — ça, c'est au code de le faire.
- **`Task.find(999)`** : l'id `999` n'existe pas dans la base de données.

## Note de lecture du jour 6

- Pour la création d'une tâche il faut deux actions : une pour ouvrir le formulaire de creation (GET /tasks/new new) et l'autre pour recevoir les informations et les enregistrées (POST /tasks create)
- Les données envoyées par la requête sont disponibles dans les paramètres
- Pour créer un formulaire on utilise la méthode <%= form_with %> et pour construire à partir d'un modèle c'est <%= form_with model : @task do |form| %>
- Pour eviter l'attaque par mass assignment on utilise les strong parameters qui designe les champs obligatoires du formulaire et fait en sorte que lors de la soumission du formulaire si un champ qui n'est pas désigné est introduit, ce dernier est rejeté en silence

Le champ caché <input type="hidden" name="authenticity_token" value="EtX2BTuA0lajWPslZyCYhCsWdErJourZUP5r_CKNqxRXTpGy0ALmUFXqdwidd37YvFn3eQFR1QXz_ZyjQ296Kw">
method = "post", les names: task[title], task[description], task[done], task[due_on], task[priority]

Les données sont dans la réponse de la requête.

La réponse a le statut 302 a cause redirect_to tasks_path qui est le statut par défaut et le navigateur envoie une requête GET vers l'url

Lorsque j'ajoute avec les DevTools <input name="task[created_at]" value="1990-01-01"> et que je soumets, alors je vérifie en console que created_at de la tâche créée n'est PAS 1990, et je retrouve la ligne Unpermitted parameter dans log/development.log

Étant donné :priority retiré de permit(...), quand je soumets une tâche en priorité haute, alors je constate que la priorité est perdue sans aucune erreur (reste normale), puis je remets :priority

### **La leçon : oublier un champ dans permit est un bug silencieux, les logs sont le seul témoin.**

## Jour 7

### Ex. 7.1

Ma décision sur due_on est que c'est pas obligatoire parce que la réceptionniste peut créer une tâche qui a une échéance inconnue depuis un téléphone

Avant, Task.create(title: "") passait parce qu'il n'y avait pas de validation au niveau du code rien que une contrainte dans la base de données qui interdisait les titres null et pas les titre chaine vide c'est pourquoi Task.create(title: nil) ne passait pas. Maintenant avec la validation au niveau du code ni l'un ni l'autre ne passe la validation attrape nil et la chaîne vide avec un message propre ; null: false reste en base comme filet de dernier recours — deux niveaux, deux rôles

## Note de lecturre Jour 8
- On passe une tâche en local au partiel pour que le partiel soit utilisable partout 
- button_to est utilisé avec les verbes POST, PUT, DELETE pour supprimer, soumettre ou modifier les données et link_to est uilisé avec le verbe GET pour les liens.
- Le status 303 requis après un DELETE pour que la redirection reparte en GET

L'utilisation de la méthode moderne redirect_back_or_to est idéale. Elle tente de renvoyer l'utilisateur sur la page d'origine. Si cette information est absente, elle applique une route de secours. **# Redirige vers la page d'origine, ou vers la liste par défaut**
**redirect_back_or_to tasks_path, notice: "Tâche modifiée**