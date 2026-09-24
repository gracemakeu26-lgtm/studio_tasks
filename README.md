# Gestionnaire de tache

Application web réalisée avec **Rails** pour un gestionaire de tache du studio lumière.

## Fonctionnalités

- **La gérante** crée et assigne les taches 
- **L'esthéticienne** voit ses taches du jour etles coche 
- **La réceptionniste** crée des tâches à la volée entre deux clientes


## Prérequis

- [Ruby](https://www.ruby-lang.org/) (v3.4.10 ou plus recommandé)
- [rails](https://rubyonrails.org/)  (v 8.1.3.1 ou plus recommandé)
- [Git](https://git-scm.com/)

## Installation

Clonez le dépôt :

```bash
git clone https://github.com/tonpseudo/nom_du_repository.git
```

Installez les dépendances :

# 1. Les dépendances système

```bash
sudo apt update && sudo apt install -y curl gpg build-essential libssl-dev libreadline-dev zlib1g-dev
libyaml-dev libsqlite3-dev git
```

# 2. RVM (clés de signature puis installation)

```bash
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
```

# 3. Ruby 3.4.10 (la compilation prend plusieurs minutes : c'est normal)

```bash
rvm install 3.4.10
rvm use 3.4.10 --default
ruby -v # ← doit afficher ruby 3.4.10
```

# 4. Rails 8 (dernière version)

```bash
gem install rails
rails -v # ← doit afficher Rails 8.x
```

## Démarrer l'application

Lancez le serveur de développement Rails:

```bash
bin/rails server
```
Puis ouvrez [http://localhost:3000](http://localhost:3000) dans votre navigateur.

## Structure du projet

```text
app/
  models/           # Les modèles les données et leurs règles 
  controllers/      # Les controlleurs reçoivent les requêtes
  views/            # Les vues les templates ERB qui deviennet du HTML 
config/
  routes.rb         # La carte des url de l'application
db/                 # La base de données 
Gemfile             # La liste des gem
Gemfile.lock        # Les versions exactes figées 
bin/                # Les commandes du projet
public/             # Les fichiers servis tels quels 
test/               # Les tests
log/                # Les journaux
tmp/                # Les fichiers temporaires 
readme.md
package.json
```

## Contribution

Les contributions sont les bienvenues !  
Pour proposer une modification :

1. Forkez le projet
2. Créez une branche : `git checkout -b feature/nouvelle-fonctionnalite`
3. Commitez vos changements : `git commit -am "Ajout nouvelle fonctionnalité"`
4. Poussez sur votre fork : `git push origin feature/nouvelle-fonctionnalite`
5. Ouvrez une *Pull Request*

**Auteur:** gracemakeu26-lgtm  
Application pour faciliter l’organisation des taches de studio lumière.