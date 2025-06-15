# Task Management System

## Présentation du projet

### Contexte
L'API de gestion des tâches est actuellement en phase de développement et offre pour l'instant une seule fonctionnalité : la création de tâches. Plus tard, il sera possible de visualiser les tâches et celles-ci seront disponibles pour chaque utilisateur.

### Technologies utilisées
- **Backend**: Node.js avec Express.js
- **Tests**: Jest
- **Linting**: ESLint
- **ORM**: Sequelize
- **Outils de développement**: Nodemon, Dotenv, Standard-Version, Winston
- **Base de données**: MySQL
- **Infrastructure as Code**: Ansible et Terraform
- **CI/CD**: GitHub Actions

## Installation

1. Cloner le dépôt
```bash
git clone https://github.com/votre-nom/task-management-system.git
cd task-management-system
```

2. Installer les dépendances
```bash
npm install
```

3. Configurer les variables d'environnement
Créez un fichier `.env` à la racine du projet avec les variables suivantes :

```
# Environnement de développement
DB_USERNAME=votre_nom_utilisateur
DB_PASSWORD=votre_mot_de_passe
DB_DATABASE=votre_base_de_donnees
DB_HOST=localhost
DB_DIALECT=mysql

# Environnement de test
TEST_DB_USERNAME=votre_nom_utilisateur_test
TEST_DB_PASSWORD=votre_mot_de_passe_test
TEST_DB_DATABASE=votre_base_de_donnees_test
TEST_DB_HOST=localhost
TEST_DB_DIALECT=mysql
```

4. Créer les bases de données
```bash
# Créez manuellement votre base de données ou utilisez :
npx sequelize-cli db:create
```

5. Exécuter les migrations
```bash
npx sequelize-cli db:migrate
```

## Scripts disponibles

- `npm start` : Démarre l'application avec nodemon pour le rechargement automatique
- `npm test` : Exécute les tests avec Jest
- `npm run lint` : Vérifie le code avec ESLint

## Structure du projet

```
task-management-system/
├── app/
│   ├── config/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   └── tests/
├── .env
├── .gitignore
├── index.js
├── package.json
└── README.md
```

## Mise en place du GitFlow

### Schéma des branches utilisées
Nous utilisons un système simplifié de GitFlow avec les branches suivantes :
- **main** : Branche principale pour le code en production.
- **develop** : Branche de développement où les nouvelles fonctionnalités sont intégrées avant d'être fusionnées dans `main`.

## Pipeline CI/CD

### Explication et lien vers les fichiers
Notre pipeline CI/CD est configuré avec GitHub Actions et comprend plusieurs workflows :

- **CI Workflow** : [Lien vers le fichier YAML](.github/workflows/ci_workflow.yml)
  - Installation des dépendances
  - Linting du code
  - Exécution des tests avec configuration de la base de données

- **CD Workflow** : [Lien vers le fichier YAML](.github/workflows/cd_workflow.yml)
  - Déploiement conditionnel basé sur la réussite du workflow CI
  - Configuration SSH et exécution des playbooks Ansible

- **Release Workflow** : [Lien vers le fichier YAML](.github/workflows/release.yml)
  - Création de releases avec Standard-Version
  - Génération automatique du CHANGELOG.md et mise à jour du package.json

### Étapes du Pipeline
1. **Installation des dépendances**
2. **Linting du code**
3. **Exécution des tests**
4. **Création de la base de données de test**
5. **Exécution des migrations**
6. **Déploiement**
7. **Création de release**

## Gestion des secrets et environnement

### Méthode utilisée
Nous utilisons des variables d'environnement via la bibliothèque `dotenv` et GitHub Secrets pour gérer les configurations sensibles.

### Séparation staging / production
La séparation entre les environnements staging et production est gérée via des fichiers de configuration spécifiques et des secrets GitHub.

### Bonnes pratiques
- Ne jamais exposer les secrets dans le code source.
- Utiliser des fichiers `.env` pour les configurations locales.
- Configurer les secrets GitHub pour les environnements de CI/CD.

## Tests et logs

### Exemple de logs
Nous utilisons Winston pour la gestion des logs. Voici un exemple de log d'erreur ou de réussite :

```plaintext
{"level":"info","message":{"ip":"::1","method":"GET","status":404,"timestamp":"2025-06-15T09:35:34.924Z","url":"/api/tasks"},"timestamp":"2025-06-15T09:35:34.924Z"}
```

## Procédures documentées
### Déploiement
Le déploiement est déclenché automatiquement via le workflow CD lorsque du code est fusionné dans la branche main. Le processus utilise Ansible et Terraform pour déployer sur notre VM GCP.

### Procédure de restauration (rollback)
En cas d'échec du déploiement, un rollback est automatiquement déclenché pour revenir à la dernière snapshot réussie. Les snapshots sont créées à chaque déploiement réussi et toutes les heures via Terraform.

### Plan de versionnage et tag
Chaque push déclenche notre pipeline de release qui appelle le script release.sh pour ajouter une nouvelle version via un tag et créer une release GitHub. Nous utilisons la bibliothèque Standard-Version pour gérer le versionnage sémantique.