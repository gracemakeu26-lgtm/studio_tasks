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

## Rituel du soir ( 24/09/2026)

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

## ## Note de lecture du 01/10/2026

* Pour la création d'une tâche il faut deux actions : une pour ouvrir le formulaire de creation (`GET /tasks/new` -> `new`) et l'autre pour recevoir les informations et les enregistrées (`POST /tasks` -> `create`)
* Les données envoyées par la requête sont disponibles dans les paramètres
* Pour créer un formulaire on utilise la méthode `<%= form_with %>` et pour construire à partir d'un modèle c'est `<%= form_with model : @task do |form| %>`
* Pour eviter l'attaque par mass assignment on utilise les strong parameters qui designe les champs obligatoires du formulaire et fait en sorte que lors de la soumission du formulaire si un champ qui n'est pas désigné est introduit, ce dernier est rejeté en silence

Le champ caché `<input type="hidden" name="authenticity_token" value="EtX2BTuA0lajWPslZyCYhCsWdErJourZUP5r_CKNqxRXTpGy0ALmUFXqdwidd37YvFn3eQFR1QXz_ZyjQ296Kw">`
* `method = "post"`
* les names: `task[title]`, `task[description]`, `task[done]`, `task[due_on]`, `task[priority]`

Les données sont dans la réponse de la requête.

La réponse a le statut `302` a cause `redirect_to tasks_path` qui est le statut par défaut et le navigateur envoie une requête GET vers l'url.

Lorsque j'ajoute avec les DevTools `<input name="task[created_at]" value="1990-01-01">` et que je soumets, alors je vérifie en console que `created_at` de la tâche créée n'est PAS 1990, et je retrouve la ligne *Unpermitted parameter* dans `log/development.log`.

Étant donné `:priority` retiré de `permit(...)`, quand je soumets une tâche en priorité haute, alors je constate que la priorité est perdue sans aucune erreur (reste normale), puis je remets `:priority`.

### ### **La leçon : oublier un champ dans permit est un bug silencieux, les logs sont le seul témoin.**

---

## ## Section de 02/10/2026

### ### Ex. 7.1

Ma décision sur `due_on` est que c'est pas obligatoire parce que la réceptionniste peut créer une tâche qui a une échéance inconnue depuis un téléphone.

Avant, `Task.create(title: "")` passait parce qu'il n'y avait pas de validation au niveau du code rien que une contrainte dans la base de données qui interdisait les titres null et pas les titre chaine vide c'est pourquoi `Task.create(title: nil)` ne passait pas. Maintenant avec la validation au niveau du code ni l'un ni l'autre ne passe la validation attrape nil et la chaîne vide avec un message propre ; `null: false` reste en base comme filet de dernier recours — deux niveaux, deux rôles.

---

## ## Note de lecturre du 05/10/20026

* On passe une tâche en local au partiel pour que le partiel soit utilisable partout 
* `button_to` est utilisé avec les verbes POST, PUT, DELETE pour supprimer, soumettre ou modifier les données et `link_to` est uilisé avec le verbe GET pour les liens.
* Le status `303` requis après un DELETE pour que la redirection reparte en GET

L'utilisation de la méthode moderne `redirect_back_or_to` est idéale. Elle tente de renvoyer l'utilisateur sur la page d'origine. Si cette information est absente, elle applique une route de secours. 

**# Redirige vers la page d'origine, ou vers la liste par défaut**  
**`redirect_back_or_to tasks_path, notice: "Tâche modifiée"`**

---

## ## Note de lecture du 06/10/2026

* L'internationnalisation est le processus de préparer une application pour q'elle prenne en charge plusieurs langues et format régionaux
* Un formulaire correct est celui qui respecte les règles UX du formulaire : 
  * Le label ne se remplace jamais par un placeholder
  * Les labels s'affiche par ordre d'iportance
  * Contient des valeurs par défaut
  * Les erreurs sont visibles et reliées aux champs
* La session de test par rôle consiste à jouer chaque rôle avec leurs workflow et dans leurs conditions de travail (debout, presser, ...)

Les messages d'erreur et les libéllés vivent dans le fichier `config/local/fr.yml`, option `config.i18n.default_locale = :fr`, avec les clés `activerecord.attributes`, `activerecord.errors`.

* **Un exemple de défaut d'écran :** voir l'importance sur la liste pour la gérante afin que quand elle voit la liste elle voit les taches, leurs importances, leurs échéances, faite ou non 
* **Un exemple de manque structurelle :** Voir les responsables des tâches

### ### Passe UX du formulaire

Les raisons de changement du formulaire c'est pour le UX (ordre des champs, priorité par défaut, boutton, placeholder)

## ## Section du 07/10/2026

* Je décide un redirect_to diférend parce que je veux que après la mise à jour que l'utilisatrice arrive directement sur la liste des tâches au lieux d'arriver sur les détails avant de retourner sur la liste.
* Le placeholder sur le champ date : ton _form.html.erb met placeholder: "jj-mm-aaaa" sur un date_field . Dans le navigateur le placeholder c'est plutôt "jj/mm/aaaa.J'ai supprimer le placeholder de date_field

## ## Section du 08/10/2026

### Comparer mon CRUD à un scaffold Rails dans une branche jetable

### 3 choses faite de la même façon que moi :

- Le partial _form.html.erb pour le formulaire utilisé dans new et edit
- La migration pour creer le schéma de données
- Les routes avec resources :notes

### 1 chose que le scaffold fait différemment que moi 

- Au niveau du controller pour la création, la mise à jour et la suppression il y a deux formats de données qui sont spécifié : html et json moi je n'ai pas ça dans mon controller
```ruby
class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /note or /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @note.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to notes_path, notice: "Note was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :title, :body ])
    end
end
```

##  La revue de code de ta propre semaine. 

### Dans tasks_controller.rb, dans update, il y avait un chemin redirect_to tasks_path(@tasks) pour le retour sur la liste des tâches après modification j'ai supprimer (@tasks) parce que tasks_path est déjà le chemin qui mènne à la liste des tâches 

### Toujours dans tasks_controller.rb, dans index, j'ai ajouter priority: :desc pour le classement par ordre de priorité

## ## Section du 12/10/2026


### Note de lecture 

- **Stateless :** C'est lorsque le serveur ne garde aucune historique des requêtes précédentes
- **Cookie signé :** Un cookie signé est un petit fichier texte stocké sur le navigateur du client, dont le contenu est accompagné d'une signature cryptographique générée par le serveur. 
- **Session en base :** C'est la méthode traditionnelle de gestion de l'état (stateful) sur le Web.
Lorsqu'un client se connecte, le serveur crée un identifiant unique et aléatoire (le Session ID ). 
- **Digest BCrypt (Empreinte BCrypt) :** Un digest BCrypt (ou empreinte/hachage BCrypt) est le résultat de la transformation d'un mot de passe en une chaîne de caractères illisible et irréversible grâce à l'algorithme BCrypt .
- Le message d'échec pour le mauvais mot de passe et l'email incorrect c'est pour que si un attaquant tente de se connecter qu'il ne sache pas réellement où il a fait l'erreur lors de la connexion

| Fichier                                    | Action                                                                                                                                                                                                               |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| User | ce fichier contient le modèle de l'utilisateur avec vérification sécurisée du mot de passe, sessions associées et normalisation de l’adresse courriel en minuscules sans espaces.|
| Session | ce fichier contient le modèle d'une session rattachée à l'utilisateur |
| le concern Authentication | Logique commune d’authentification : reprend la session depuis le cookie, redirige les visiteurs non connectés et crée ou termine une session. |
| Current | Conserve la session de l'utilisateur courant pendant une requête |
| SessionsController#create | Affiche le formulaire de création  |
| la ligne has_secure_password | Vérification sécurisé du mot de passe |

- Le garde qui protège toutes les pages est situé dans controller/application_controller.rb à la ligne 2 (include Authentication)

- Étant donné une migration AddNameAndRoleToUsers (name:string, role:string, null: false sur les deux), quand je la RELIS avant de la lancer, alors je vérifie que le nom et le rôle ne peuvent être nuls.

- Preuve que le mot de passe en clair n'existe nulle part en base : ` "$2a$12$IwEPFUx9w29IK4QDg.OjbuQJ5tLjxnOecCgDY3HJ4c0advfBwrrfK" `

- Étant donné le serveur lancé, quand je visite /tasks déconnectée, alors je suis redirigée vers la connexion ci-dessous : 
![Ecran de connexion](/docs/captures/ecran-connexion.png)

- Étant donné la connexion au compte gérante, quand j'ouvre DevTools → Application → Cookies, alors je trouve le cookie de session, je note qu'il est illisible (suite de lettre et de chiffre) et que HttpOnly (inaccessible au javascript de la page) est coché.

- Étant donné le cookie modifié à la main, quand je recharge, alors  la page se recharge et me redirige instantanément vers l'écran de connexion. Un nouveau cookie de session vierge remplace celui qui a été modifié. Parce que le serveur a ajouté une signature au cookie pour garantir son authenticité.

- Étant donné un button_to « Se déconnecter » (session_path, method: :delete) ajouté au layout, quand je clique, alors je reviens à l'écran de connexion(redirection -> connexion -> accès -> deconnexion -> redirection)

## ## Section du 13/10/2026


### Note de lecture 

- **Foreign key :** Clé étrangère, la colonne qui contient l'id d'une autre table
- **has_many / belongs_to :** association un-à-plusieurs qui donne les méthodes de naviguation dans les deux sens (awa.tasks et task.user)
- **Ce que add_reference crée :** la colonne user_id , un index et une contrainte de clé étrangère en base 
- **belongs_to obligatoire par défaut depuis Rails 5 :** Pour renforcer l'intégrité des données au niveau de l'application et éviter les enregistrements "orphelins" (une tâche doit avoir un responsable)
- **dependent: :nullify vs :destroy :** nullify permet de supprimer un utilisateur sans supprimer ses tâches alors que destroy permet de supprimer un utilisateur et ses tâches
- **Un scope :** est une requête réutilisable déclaré dans le modéle (une requête qui revient partout)
- **Relire le code** est une règle qui s'applique à la migration que je vais créer

- Dans la migration add_user_to_tasks.rb, j'ai changé null: false à nul: true parce que on veux les tâches non assignées
- Dans schema.rb on voit la colone user_id `(t.integer "user_id")`, l'index `(t.index ["user_id"], name: "index_tasks_on_user_id")` et la foreign key `( add_foreign_key "tasks", "users")` après la migration
- Les tâches existantes en console : 
``` ruby
id: 181,
 title: "Commander le gel",
 description: nil,
 done: false,
 due_on: "2026-10-11",
 priority: 2,
 created_at: "2026-10-12 11:30:28.838400000 +0000",
 updated_at: "2026-10-12 11:30:28.838400000 +0000",
 user_id: nil
 ```

- **has_many :tasks, dependent: :nullify** Parce que les tâches survivent après le depart de l'employé
- **belongs_to :user, optional: true** Parce que la réceptionniste assigne les tâches à la volée donc les tâches « à prendre » doivent exister

En console 
``` ruby
 - user.tasks
  Task Load (0.4ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."user_id" = 1 /* loading for pp */ LIMIT 11 /*application='StudioTasks'*/
 => [] 
 - task.user
 => nil 
 - user.tasks.where(done: false).order(:due_on)
  Task Load (0.4ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."user_id" = 1 AND "tasks"."done" = FALSE /* loading for pp */ ORDER BY "tasks"."due_on" ASC LIMIT 11 /*application='StudioTasks'*/
 => [] 
 - user.tasks.create(title: "Vérifier la caisse")
  TRANSACTION (0.3ms)  BEGIN immediate TRANSACTION /*application='StudioTasks'*/
  Task Create (1.9ms)  INSERT INTO "tasks" ("title", "description", "done", "due_on", "priority", "created_at", "updated_at", "user_id") VALUES ('Vérifier la caisse', NULL, FALSE, NULL, 1, '2026-10-13 15:03:38.950742', '2026-10-13 15:03:38.950742', 1) RETURNING "id" /*application='StudioTasks'*/
  TRANSACTION (66.7ms)  COMMIT TRANSACTION /*application='StudioTasks'*/
 => 
#<Task:0x0000760e1fcbe398
 id: 191,
 title: "Vérifier la caisse",
 description: nil,
 done: false,
 due_on: nil,
 priority: 1,
 created_at: "2026-10-13 15:03:38.950742000 +0000",
 updated_at: "2026-10-13 15:03:38.950742000 +0000",
 user_id: 1> 
 ```
- Quand j'appelle task.user sur une tache non assignée ça rend nil
- task.user.name exploserait parce qu'on tente d'appelé la methode name sur nil ça ressemble au bug javascipt qui appellait la méthode parsefloat sur undefined

Les scopes 

- 3.4.10 :024 > Task.overdue.count
  Task Count (2.4ms)  SELECT COUNT(*) FROM "tasks" WHERE "tasks"."done" = FALSE AND (due_on < '2026-10-13') /*application='StudioTasks'*/
 => 4 
- 3.4.10 :007 > Task.where("due_on > ?", Date.today).count
  Task Count (0.4ms)  SELECT COUNT(*) FROM "tasks" WHERE (due_on > '2026-10-13') /*application='StudioTasks'*/
 => 3 
- 3.4.10 :001 > Task.open_tasks.count
  Task Count (0.3ms)  SELECT COUNT(*) FROM "tasks" WHERE "tasks"."done" = FALSE /*application='StudioTasks'*/
 => 6 
- 3.4.10 :006 > Task.where(done: true).count
  Task Count (0.3ms)  SELECT COUNT(*) FROM "tasks" WHERE "tasks"."done" = TRUE /*application='StudioTasks'*/
 => 5 
- 3.4.10 :004 > Task.unassigned.count
  Task Count (0.5ms)  SELECT COUNT(*) FROM "tasks" WHERE "tasks"."user_id" IS NULL /*application='StudioTasks'*/
 => 10 
- 3.4.10 :009 > Task.where(user_id: 1).count
  Task Count (0.3ms)  SELECT COUNT(*) FROM "tasks" WHERE "tasks"."user_id" = 1 /*application='StudioTasks'*/
 => 1 
 - même règle que les deux chemins d'un formulaire — s'applique aussi aux scopes dans mon projet

- db:reset reinitialise la base de données elle supprime d'abord ce qui était là et recrée la base 