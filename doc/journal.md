# Journal

## L'installation

* **Ruby** ruby 3.4.10
* **Rails** Rails 8.1.3.1
* **which ruby** `/home/grace/.rvm/rubies/ruby-3.4.10/bin/ruby`

---

## Expédition dans le squelette

| Dossiers | Action |
| --- | --- |
| `config/routes.rb` | Ce dossier/fichier contient la carte des URL (chemins) de l'application, j'y toucherai quand je devrai créer une nouvelle page accessible ou modifier l'adresse d'un lien. |
| `Gemfile` | Ce fichier contient la liste des bibliothèques externes (gems) requises, j'y toucherai quand je devrai installer un nouvel outil (comme un système d'authentification) ou mettre à jour une dépendance. |
| `db/` | Ce dossier contient les fichiers de configuration et de migration de la base de données, j'y toucherai quand je devrai créer une nouvelle table ou modifier un champ existant. |
| `app/controllers/application_controller.rb` | Ce dossier contient la logique qui reçoit et traite les requêtes des utilisateurs, j'y toucherai quand je devrai récupérer des données pour les envoyer à une vue ou rediriger l'utilisateur. |
| `app/models/` | Ce dossier contient les données de l'application et leurs règles métiers, j'y toucherai quand je devrai créer un nouveau type d'objet ou ajouter des validations sur les données. |
| `app/views/` | Ce dossier contient les templates HTML/ERB pour afficher l'interface, j'y toucherai quand je devrai modifier le design, ajouter du texte ou changer le visuel d'une page. |
| `test/` | Ce dossier contient les scripts de tests automatisés de l'application, j'y toucherai quand je devrai écrire des scénarios pour vérifier que mon code fonctionne correctement et éviter les bugs. |
| `public/` | Ce dossier contient les fichiers statiques servis tels quels (pages d'erreur, robots.txt), j'y toucherai quand je devrai personnaliser la page d'erreur 404 ou ajouter des fichiers accessibles directement par URL. |

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

* **Pourquoi RVM plutôt qu'un Ruby système ?** Parce que RVM permet d'installer plusieurs versions de Ruby pour permettre de travailler sur des projets qui utilisent des versions différentes.
* **À quoi sert le `Gemfile.lock` ?** Il gère et fige les versions exactes de gem.
* **Et que veut dire convention over configuration — avec un exemple vu aujourd'hui ?** Rails décide de l'organisation à ma place. Un exemple : `rails new` génère le squelette complet d'une application.

---

## Tracé papier de `GET /tasks/1` et les erreurs `/machin`, `/tasks/new`, `/tasks/999`

### Tracé papier des routes

| Prefix | Verb | URI Pattern | Controller#Action |
| --- | --- | --- | --- |
| `tasks` | GET | `/tasks(.:format)` | `tasks#index` |
|  | POST | `/tasks(.:format)` | `tasks#create` |
| `new_task` | GET | `/tasks/new(.:format)` | `tasks#new` |
| `edit_task` | GET | `/tasks/:id/edit(.:format)` | `tasks#edit` |
| `task` | GET | `/tasks/:id(.:format)` | `tasks#show` |
|  | PATCH | `/tasks/:id(.:format)` | `tasks#update` |
|  | PUT | `/tasks/:id(.:format)` | `tasks#update` |
|  | DELETE | `/tasks/:id(.:format)` | `tasks#destroy` |
| `root` | GET | `/` | `tasks#index` |

### Tracé papier de `GET /tasks/1`

```
GET tasks/1 ==> config/routes.rb ==> app/controllers/tasks_controller.rb
==> app/models/task.rb ==> app/views/tasks/show.html.erb ==> HTML (navigateur)
```

Le numéro `1` va dans l'objet `params[:id]` du contrôleur, ce qui permet de l'utiliser pour envoyer une requête à la base de données.

### Les erreurs `/machin`, `/tasks/new`, `/tasks/999`

* **`/machin`** : aucune route ne correspond à `/machin` dans `config/routes.rb`.
* **`/tasks/new`** : la route `/tasks/new` existe mais l'action `new` du contrôleur n'existe pas.
* **`/tasks/999`** : la route `/tasks/999` existe et l'action `show` du contrôleur existe.

---

### Les 3 requêtes de la gérante et la décision « une tâche faite est-elle en retard ? »

* **Les tâches non faites, les plus urgentes d'abord ?**
  ```ruby
  Task.where(done: false).order(:due_on)
  ```

* **Combien de tâches en retard ?**
  ```ruby
  Task.where(done: false).where("due_on < ?", Date.today).count
  ```

* **La tâche n°2, marque-la faite :**
  ```ruby
  task = Task.find(2)
  task.done = true
  task.save
  ```

---

## `Task.create(title: nil)`, `Task.create(title: "")`, `Task.find(999)`

* **`Task.create(title: nil)`** : la contrainte empêche de créer un titre `nil`.
* **`Task.create(title: "")`** : la contrainte empêche de créer un titre `nil` mais pas un titre vide — ça, c'est au code de le faire.
* **`Task.find(999)`** : l'id `999` n'existe pas dans la base de données.