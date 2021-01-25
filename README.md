# devops_project

Mise en place d’un pipeline CI/CD.
Dans ce projet, nous devons mettre en place un pipeline CI/CD comme suit :

## Architecture 

Pour ce faire, nous avons choisi de monter notre architecture en local sur la base de deux machines virtuelles :
-	Un serveur de déploiement (CI/CD)
-	Un serveur d’application 

La partie développement (Dev) sera intégralement construite en langage Go. Il s’agit d’une application web qui affiche un message « Hello DevOps » avec des tests unitaires. Le projet est versionné par Git et disponible sur GitHub. Vous le trouverez dans le dépôt public https://github.com/coolioalexander/devops_project.git.

Le serveur de déploiement est composé d’un système de build (Jenkins), d’un outil de déploiement (Ansible) et d’une technologie de conteneurisation (Docker).
Le serveur d’application est composé de Docker qui nous permettra de démarrer l’application web dans un conteneur.
Description du pipeline
A chaque push de notre projet vers le dépôt GitHub, un webHook est configuré pour démarrer automatiquement un build sur le serveur de déploiement à partir d’un Jenkinsfile.
Jenkins se charge de récupérer la dernière version du projet, de faire un build et des tests unitaires de l’application dans un conteneur Go. Une fois ces étapes passées, une image docker de notre application est créée à partir d’un Dockerfile. Ensuite, cette image est scannée par le scanner d’images Clair et ensuite envoyée vers un artifactory ; il s’agit d’un dépôt d’images sur DockerHub. Après, Ansible se charge de déployer cette image docker sur notre serveur d’application au moyen d’un playbook. Après cette étape, notre application est accessible sur le serveur. Pour finir, des tests de sécurité (attaque XSS) sont appliqués grâce à Guantlt et Arachni.

## Structure du projet

Le provisionnement des serveurs locaux (deployment_vm et app_vm) a été fait à partir de Vagrant. Une fois les deux serveurs démarrés, on aura besoin de leurs adresses IP pour configurer notre pipeline. L’adresse de app_vm (serveur d’application) sera ajoutée dans le fichier hosts de Ansible et dans le fichier xss.attack de Gauntlt. Pour configurer le webHook de GitHub, il nous faut une adresse sur internet et non une adresse locale. L’outil ngrok nous fournit une adresse à partir de l’adresse locale grâce à la commande « ngrok http adresse_ip ». L’adresse de deployment_vm sera ajoutée dans la configuration du webHook. Rappelons également qu’il faut configurer Jenkins une fois démarré sur le port 8080. Il faudra ajouter les credentials de notre compte DockerHub au nom de « my-docker-credential-id » dans le Jenkinsfile et installer les plugins Docker, Golang et Ansible.

## Démonstration

1-	Obtention d’une adresse sur internet du serveur de déploiement grâce à ngrok.
2-	Configuration de l’adresse du serveur d’application dans hosts.yml et xss.attack.
3-	Démarrage du build dans Jenkins après un push du projet sur GitHub.
4-	Résultats du build de Jenkins
4.1- SCM 
4.2- Build
4.3- Tests
4.4- Docker Build 
4.5-Docker Scan : Clair
4.6- Docker Push
4.7- Ansible Deploy
5-	Push de l’image sur DockerHub
6-	Déploiement de l’application : le message « Hello DevOps » s’affiche une fois le conteneur déployé.
7-	Test de sécurité : Gauntlt + Arachni
8-	Résultat du pipeline
