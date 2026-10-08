# Gestionnaire de tâches - Studio Lumière

Application web développée avec Ruby on Rails pour organiser et suivre les tâches d’un studio de beauté / esthétique. Elle permet de créer, modifier, supprimer et trier des tâches selon leur priorité, leur date d’échéance et leur statut d’avancement.

## Aperçu

Ce projet est une petite application de gestion opérationnelle destinée à faciliter le suivi quotidien du travail entre les différents membres du studio :

- la gérante peut créer et organiser les tâches ;
- l’esthéticienne peut consulter les tâches à réaliser et les marquer comme terminées ;
- la réceptionniste peut ajouter rapidement des tâches en cours de journée.

## Fonctionnalités

- Créer une nouvelle tâche avec titre, description, priorité et date d’échéance ;
- Modifier ou supprimer une tâche existante ;
- Marquer une tâche comme terminée ou non terminée ;
- Trier les tâches par statut, date d’échéance et priorité ;
- Accéder à la liste des tâches via la page d’accueil ;
- Gestion des validations côté serveur avec Active Record.

## Stack technique

- Ruby 3.4+
- Rails 8.1+
- SQLite 3
- HTML / ERB / CSS

## Prérequis

Avant de lancer le projet, assurez-vous d’avoir installé :

- [Ruby](https://www.ruby-lang.org/)
- [Rails](https://rubyonrails.org/)
- [Bundler](https://bundler.io/)
- [Git](https://git-scm.com/)

## Installation

1. Clonez le dépôt :

```bash
git clone <url-du-repo>
cd studio_tasks
```

2. Installez les dépendances Ruby :

```bash
bundle install
```

3. Configurez la base de données :

```bash
bin/rails db:create db:migrate
```

4. Si vous souhaitez charger des données de démonstration :

```bash
bin/rails db:seed
```

## Démarrage

Lancez le serveur de développement :

```bash
bin/rails server
```

Puis ouvrez l’application dans votre navigateur :

- http://localhost:3000

## Structure du projet

```text
app/
  controllers/     # Contrôleurs Rails
  models/          # Modèles de données
  views/           # Vues ERB
  assets/          # Fichiers CSS / images
  javascript/      # Scripts front-end
config/
  routes.rb        # Définition des routes
  database.yml     # Configuration de la base de données
  environments/    # Paramétrage des environnements
  initializers/    # Initialisation Rails
db/
  migrate/         # Migrations de la base
  schema.rb        # Schéma actuel de la BD
test/
  controllers/     # Tests de contrôleurs
  models/          # Tests de modèles
Gemfile            # Dépendances du projet
Rakefile           # Tâches Rake
README.md          # Documentation du projet
```

## Routes principales

- GET / → liste des tâches
- GET /tasks → liste des tâches
- GET /tasks/new → formulaire de création
- POST /tasks → création d’une tâche
- GET /tasks/:id → détail d’une tâche
- GET /tasks/:id/edit → formulaire de modification
- PATCH/PUT /tasks/:id → mise à jour
- DELETE /tasks/:id → suppression

## Créer, modifier et supprimer une tâche

### Créer une tâche

1. Cliquez sur le bouton "Créer une tâche" depuis la page d’accueil.
2. Remplissez le formulaire avec le titre, la description, la date d’échéance et la priorité.
3. Cliquez sur "Enregistrer la tâche" pour sauvegarder la tâche.
4. La tâche apparaîtra alors dans la liste principale.

### Modifier une tâche

1. Ouvrez la tâche depuis la liste.
2. Cliquez sur le lien de modification.
3. Mettez à jour les informations souhaitées.
4. Validez en enregistrant les changements.

### Supprimer une tâche

1. Sélectionnez la tâche concernée.
2. Cliquez sur l’action de suppression.
3. Confirmez la suppression lorsqu’une demande de confirmation apparaît.
4. La tâche est retirée de la liste et ne sera plus visible dans l’application.

## Locale (internationalisation)

Le projet utilise l’internationalisation Rails avec des fichiers de traduction dans le dossier `config/locales`.

- `config/locales/fr.yml` contient les libellés et messages de l’interface en français.
- `config/locales/en.yml` contient les traductions de base en anglais.
- Les libellés de modèles, formulaires et messages flash sont centralisés dans ces fichiers pour faciliter la traduction ou l’ajout d’une nouvelle langue.

Pour activer une locale différente ou ajouter des traductions, il suffit de modifier ou de compléter les clés de traduction dans ces fichiers et d’utiliser les helpers Rails comme `t(...)` ou `I18n.t(...)` dans les vues et contrôleurs.

## Tests

Pour lancer la suite de tests :

```bash
bin/rails test
```

## Contribution

Les contributions sont bienvenues. Pour proposer une amélioration :

1. Créez une branche :

```bash
git checkout -b feature/ma-fonctionnalite
```

2. Effectuez les modifications.
3. Validez les changements :

```bash
git add .
git commit -m "Ajout de ma fonctionnalité"
```

4. Pousser la branche :

```bash
git push origin feature/ma-fonctionnalite
```

5. Ouvrez une pull request.

## What I built this week, and what I would test first if I joined this project as a QA

What I built this week was a small Rails task manager for a beauty studio.  
It lets staff create, edit, complete, and delete tasks with priorities and deadlines.  
I also added French localization so the interface feels natural for daily operations.  
The app is simple, fast, and designed for quick daily task tracking.  
If I joined this project as a QA, I would test the task creation flow first.  
I would verify required fields, valid dates, and priority values before saving.  
Next, I would check edit and delete actions to confirm the right task is updated or removed.  
I would also test the done toggle and sorting by date and priority.  
Then I would validate empty and populated states, including error messages and flash notices.  
Finally, I would confirm the French locale and interface behave correctly across the main user journeys.

## Auteur

Projet réalisé dans le cadre d’un développement de gestion de tâches pour un studio de beauté / esthétique.

## Licence

Ce projet est fourni à des fins d’apprentissage et de démonstration. La licence exacte peut être ajoutée selon les besoins du projet.