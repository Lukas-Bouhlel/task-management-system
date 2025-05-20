# Task Management System

A Node.js and Express-based task management API with Sequelize ORM integration.

## Prérequis

- Node.js (v18+)
- MySQL ou autre base de données supportée par Sequelize
- Git

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

## Contribution

1. Créez une branche pour votre fonctionnalité (`git checkout -b feature/amazing-feature`)
2. Committez vos changements (`git commit -m 'Add some amazing feature'`)
3. Poussez vers la branche (`git push origin feature/amazing-feature`)
4. Ouvrez une Pull Request

## CI/CD

Ce projet utilise GitHub Actions pour l'intégration continue et le déploiement continu.
- Les tests et la vérification de code sont exécutés sur chaque push et pull request
- Le déploiement est automatisé pour les branches main/master