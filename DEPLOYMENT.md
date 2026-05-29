# 🚀 Guide de Déploiement GitHub Pages

Ce guide explique comment déployer le monorepo sur GitHub Pages avec les 4 jeux d'horreur générés par différentes IA.

## 📋 Table des matières

- [Déploiement Local](#déploiement-local)
- [Déploiement Automatisé](#déploiement-automatisé)
- [Configuration de GitHub Pages](#configuration-de-github-pages)
- [Troubleshooting](#troubleshooting)

---

## Déploiement Local

### Prérequis

- **Node.js** (version 18+)
- **npm** ou **yarn**
- Bash (Linux, macOS ou WSL sur Windows)

### Étapes

1. **Clonez le repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/video-battle-ia-horreur-github-pages.git
   cd video-battle-ia-horreur-github-pages
   ```

2. **Rendez le script exécutable**
   ```bash
   chmod +x deploy.sh
   ```

3. **Exécutez le script de déploiement**
   ```bash
   ./deploy.sh
   ```

   Le script va :
   - 📦 Installer les dépendances de chaque projet
   - 🔨 Construire chaque jeu (ChatGPT, Claude, Composer, Gemini)
   - 📁 Organiser les fichiers buildés dans le dossier `dist/`
   - 🏠 Créer une page d'accueil automatique

4. **Vérifiez le résultat**
   ```bash
   ls -la dist/
   # Vous devriez voir:
   # - dist/index.html (page d'accueil)
   # - dist/chatgpt/
   # - dist/claude/
   # - dist/composer/
   # - dist/gemini/
   ```

### Prévisualiser localement

Vous pouvez servir les fichiers générés localement :

```bash
# Avec Python 3
python -m http.server 8000 --directory dist

# Ou avec Node.js
npx http-server dist
```

Puis ouvrez `http://localhost:8000` dans votre navigateur.

---

## Déploiement Automatisé

Ce repository est configuré avec **GitHub Actions** pour un déploiement automatique.

### Configuration

Le workflow se déclenche automatiquement quand vous :
- 📤 **Pousser vers `main` ou `master`**
- 🔄 **Créer une Pull Request**
- ⚙️ **Déclencher manuellement** via la section Actions

### Fichier Workflow

Le fichier `.github/workflows/deploy.yml` automatise :
1. Installation de Node.js
2. Exécution du script de déploiement
3. Upload sur GitHub Pages

### Status du Déploiement

Consultez les logs du déploiement :
1. Allez dans l'onglet **Actions** de votre repository
2. Cliquez sur le workflow **"Déployer sur GitHub Pages"**
3. Vérifiez les logs de construction et de déploiement

---

## Configuration de GitHub Pages

### Étape 1: Configurer le Repository

1. Allez dans **Settings** → **Pages**
2. Sous **Build and deployment** :
   - **Source** : Sélectionnez "Deploy from a branch"
   - **Branch** : Sélectionnez `gh-pages`
   - **Folder** : `/root`
3. Cliquez sur **Save**

### Étape 2: Première Exécution

1. Allez dans l'onglet **Actions**
2. Cherchez le workflow **"Déployer sur GitHub Pages"**
3. Cliquez sur **Run workflow** → **Run workflow**
4. Le déploiement va créer la branche `gh-pages` automatiquement

### Étape 3: Vérifier le Déploiement

Une fois le workflow terminé :
1. Allez dans **Settings** → **Pages**
2. Vous devriez voir le message : *"Your site is live at https://username.github.io/video-battle-ia-horreur-github-pages"*
3. Cliquez sur le lien pour vérifier votre site

---

## Architecture du Déploiement

```
dist/
├── index.html          # Page d'accueil avec les 4 jeux
├── chatgpt/
│   ├── index.html
│   ├── assets/
│   └── ...
├── claude/
│   ├── index.html
│   ├── assets/
│   └── ...
├── composer/
│   ├── index.html
│   ├── assets/
│   └── ...
└── gemini/
    ├── index.html
    ├── assets/
    └── ...
```

Chaque jeu est dans son propre sous-dossier avec tous ses fichiers nécessaires.

---

## Troubleshooting

### ❌ Le script échoue avec "permission denied"

```bash
chmod +x deploy.sh
./deploy.sh
```

### ❌ "Node/npm not found"

Installez Node.js :
- [nodejs.org](https://nodejs.org/) - Installez la version LTS

### ❌ Erreurs de build pour un projet

Le script continue même si un projet échoue. Vérifiez :
1. **Logs du script** pour voir quel projet a échoué
2. **Dépendances** du projet problématique :
   ```bash
   cd [projet]
   npm install
   npm run build
   ```

### ❌ GitHub Pages ne se met pas à jour

1. Vérifiez que le workflow s'est terminé avec succès
2. Videz le cache du navigateur (Ctrl+Shift+Delete)
3. Forcez le rechargement (Ctrl+F5)
4. Attendez quelques minutes (le déploiement peut prendre du temps)

### ❌ "dist/ folder not found"

Assurez-vous que :
1. Le script s'est exécuté sans erreurs
2. Tous les projets ont un `dist/` après le build
3. Vous êtes dans le dossier racine du monorepo

---

## Commandes Utiles

### Build manuel d'un projet

```bash
cd [projet]
npm install
npm run build
```

### Nettoyer et redéployer

```bash
rm -rf dist/
./deploy.sh
```

### Voir le status des Actions

```bash
gh run list --repo YOUR_USERNAME/video-battle-ia-horreur-github-pages
```

### Déclencher manuellement le workflow

```bash
gh workflow run deploy.yml --repo YOUR_USERNAME/video-battle-ia-horreur-github-pages
```

---

## Support et Aide

- 📹 Regardez la vidéo YouTube sur la chaîne [Aywen](https://www.youtube.com/@AywenVideos)
- 🐛 Signalez les bugs via GitHub Issues
- 💬 Discussions disponibles dans l'onglet "Discussions" du repository

---

## Notes de Sécurité

⚠️ **Important** :
- Le code est fourni à titre **éducatif et expérimental**
- Les jeux peuvent contenir des **bugs** ou des **failles de sécurité**
- Testez localement avant de déployer
- Signalez les failles de sécurité en privé

---

## Licence

Voir [README.md](../README.md) pour les conditions d'utilisation et les crédits.
