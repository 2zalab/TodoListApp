# Todo List App

Une application de liste de tâches simple développée avec Flutter. Cette application permet aux utilisateurs d'ajouter, de supprimer et de filtrer des tâches. Elle inclut également une fonctionnalité de connexion et d'inscription.

## Fonctionnalités

- Ajouter des tâches
- Supprimer des tâches
- Cocher les tâches terminées
- Restaurer les tâches supprimées
- Filtrer les tâches par statut (terminées, non terminées)
- Authentification avec inscription et connexion

## Prérequis

Avant de commencer, assurez-vous d'avoir les éléments suivants installés :

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Un éditeur de code comme [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)

## Installation

1. Clonez le dépôt :

```sh
git clone https://github.com/touza-isaac/TodoListApp.git
```

2. Naviguez dans le répertoire du projet :

```sh
cd votre-repo
```

3. Installez les dépendances :

```sh
flutter pub get
```

## Utilisation

1. Exécutez l'application :

```sh
flutter run
```

2. Utilisez l'application pour ajouter, supprimer et filtrer les tâches.

## Architecture

L'application est structurée en deux parties principales : `LoginApp` et `TodoApp`. 

### `LoginApp`

Cette partie gère l'authentification des utilisateurs, y compris l'inscription et la connexion.

- `registrationScreen.dart`: Écran d'inscription des utilisateurs.
- `signIn.dart`: Écran de connexion des utilisateurs.

### `TodoApp`

Cette partie gère les fonctionnalités de la liste de tâches.

- `apiMain.dart`: Gestion des tâches via une API (à préciser).
- `jsonMain.dart`: Gestion des tâches en utilisant un fichier JSON local.
- `listMain.dart`: Affichage de la liste de tâches.
- `main.dart`: Point d'entrée principal de l'application.

### Structure des fichiers

```
lib/
├── LoginApp/
│   ├── registrationScreen.dart
│   └── signIn.dart
├── TodoApp/
│   ├── apiMain.dart
│   ├── jsonMain.dart
│   ├── listMain.dart
│   └── main.dart
```

## Contribuer

Les contributions sont les bienvenues ! Si vous avez des suggestions ou des améliorations, veuillez créer une issue ou soumettre une pull request.

1. Fork le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos modifications (`git commit -m 'Add some AmazingFeature'`)
4. Poussez votre branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une pull request

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Contact

Votre Nom - [@touzaisaac](https://twitter.com/touzaisaac) - votre-email@example.com

Lien du projet: [https://github.com/touza-isaac/TodoListApp](https://github.com/touza-isaac/TodoListApp)
