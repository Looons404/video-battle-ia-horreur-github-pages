#!/bin/bash

# ========================================
# Script de déploiement GitHub Pages
# Monorepo: ChatGPT vs Claude vs Composer vs Gemini
# ========================================

set -e

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROJECTS=("chatgpt" "claude" "composer" "gemini")
DEPLOY_DIR="dist"
TIMESTAMP=$(date +%Y-%m-%d\ %H:%M:%S)

# Fonction pour afficher les messages
log_info() {
  echo -e "${BLUE}ℹ ${1}${NC}"
}

log_success() {
  echo -e "${GREEN}✓ ${1}${NC}"
}

log_warning() {
  echo -e "${YELLOW}⚠ ${1}${NC}"
}

log_error() {
  echo -e "${RED}✗ ${1}${NC}"
}

# Fonction pour construire un projet
build_project() {
  local project=$1
  local project_path="./${project}"

  if [ ! -d "$project_path" ]; then
    log_error "Le dossier ${project} n'existe pas"
    return 1
  fi

  log_info "📦 Construction de ${project}..."
  
  cd "$project_path"
  
  # Installer les dépendances
  if [ -f "package.json" ]; then
    log_info "  → Installation des dépendances..."
    npm install
    
    # Construire le projet
    log_info "  → Build du projet..."
    npm run build
    
    log_success "  → ${project} construit avec succès"
  else
    log_error "  → Pas de package.json trouvé dans ${project}"
    cd ..
    return 1
  fi
  
  cd ..
}

# Fonction pour copier les fichiers buildés
copy_build() {
  local project=$1
  local source="${project}/dist"
  local destination="${DEPLOY_DIR}/${project}"

  if [ ! -d "$source" ]; then
    log_error "Pas de dossier dist trouvé pour ${project}"
    return 1
  fi

  mkdir -p "$destination"
  cp -r "$source"/* "$destination/"
  log_success "Fichiers de ${project} copiés vers ${destination}"
}

# Fonction pour créer une page d'accueil
create_index() {
  cat > "${DEPLOY_DIR}/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Jeux d'Horreur - Comparaison IA</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
      color: #e0e0e0;
      line-height: 1.6;
      min-height: 100vh;
      padding: 20px;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
    }

    header {
      text-align: center;
      margin-bottom: 50px;
      padding: 40px 0;
    }

    h1 {
      font-size: 3em;
      margin-bottom: 10px;
      background: linear-gradient(45deg, #ff6b6b, #ee5a6f, #c44569);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .subtitle {
      font-size: 1.2em;
      color: #b0b0b0;
      margin-bottom: 30px;
    }

    .description {
      background: rgba(255, 255, 255, 0.05);
      padding: 20px;
      border-radius: 10px;
      border-left: 4px solid #ff6b6b;
      margin-bottom: 40px;
      max-width: 800px;
      margin-left: auto;
      margin-right: auto;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 30px;
      margin-bottom: 40px;
    }

    .card {
      background: rgba(255, 255, 255, 0.08);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 15px;
      padding: 30px;
      text-align: center;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #ff6b6b, #ee5a6f, #c44569);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform 0.3s ease;
    }

    .card:hover {
      background: rgba(255, 255, 255, 0.12);
      border-color: rgba(255, 255, 255, 0.2);
      transform: translateY(-5px);
    }

    .card:hover::before {
      transform: scaleX(1);
    }

    .card-icon {
      font-size: 3em;
      margin-bottom: 15px;
    }

    .card-title {
      font-size: 1.5em;
      margin-bottom: 10px;
      font-weight: bold;
    }

    .card-description {
      color: #a0a0a0;
      margin-bottom: 20px;
      font-size: 0.95em;
    }

    .btn {
      display: inline-block;
      padding: 12px 30px;
      background: linear-gradient(45deg, #ff6b6b, #ee5a6f);
      color: white;
      text-decoration: none;
      border-radius: 25px;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      font-size: 1em;
      font-weight: 600;
    }

    .btn:hover {
      background: linear-gradient(45deg, #ff5252, #ee4464);
      transform: scale(1.05);
    }

    footer {
      text-align: center;
      padding: 40px 0;
      color: #707070;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      margin-top: 50px;
    }

    .credits {
      font-size: 0.9em;
      margin: 10px 0;
    }

    .credits a {
      color: #ff6b6b;
      text-decoration: none;
    }

    .credits a:hover {
      text-decoration: underline;
    }

    @media (max-width: 768px) {
      h1 {
        font-size: 2em;
      }

      .grid {
        grid-template-columns: 1fr;
        gap: 20px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>🎮 Jeux d'Horreur - Comparaison IA</h1>
      <p class="subtitle">ChatGPT vs Claude vs Composer vs Gemini</p>
      <div class="description">
        <p>Découvrez comment 4 intelligences artificielles différentes interprètent et créent le même jeu d'horreur. Une expérience unique pour comparer les capacités de génération de code des IA modernes.</p>
      </div>
    </header>

    <div class="grid">
      <div class="card">
        <div class="card-icon">🤖</div>
        <div class="card-title">ChatGPT</div>
        <p class="card-description">La version générée par OpenAI</p>
        <a href="./chatgpt/" class="btn">Jouer</a>
      </div>

      <div class="card">
        <div class="card-icon">🧠</div>
        <div class="card-title">Claude</div>
        <p class="card-description">La version générée par Anthropic</p>
        <a href="./claude/" class="btn">Jouer</a>
      </div>

      <div class="card">
        <div class="card-icon">✨</div>
        <div class="card-title">Composer</div>
        <p class="card-description">La version générée par Composer 2.5</p>
        <a href="./composer/" class="btn">Jouer</a>
      </div>

      <div class="card">
        <div class="card-icon">🔮</div>
        <div class="card-title">Gemini</div>
        <p class="card-description">La version générée par Google</p>
        <a href="./gemini/" class="btn">Jouer</a>
      </div>
    </div>

    <footer>
      <div class="credits">
        <p>Projet créé par <a href="https://aywen.fr/" target="_blank">Aywen</a></p>
        <p>Effets sonores provenant de <a href="https://pixabay.com/fr/sound-effects/" target="_blank">Pixabay</a></p>
        <p style="margin-top: 20px; color: #505050;">⚠️ Code fourni à titre éducatif et expérimental</p>
      </div>
    </footer>
  </div>
</body>
</html>
EOF
  log_success "Page d'accueil créée"
}

# Fonction principale
main() {
  echo ""
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║   Déploiement GitHub Pages - Monorepo Jeux d'Horreur   ║${NC}"
  echo -e "${BLUE}║                    ${TIMESTAMP}                 ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Vérifier que nous sommes à la racine du monorepo
  if [ ! -f "README.md" ]; then
    log_error "Vous devez exécuter ce script à la racine du monorepo"
    exit 1
  fi

  # Nettoyer le dossier de déploiement existant
  if [ -d "$DEPLOY_DIR" ]; then
    log_warning "Suppression du dossier ${DEPLOY_DIR} existant..."
    rm -rf "$DEPLOY_DIR"
  fi

  mkdir -p "$DEPLOY_DIR"
  log_success "Dossier de déploiement créé: ${DEPLOY_DIR}"
  echo ""

  # Construire tous les projets
  local failed_projects=()
  
  for project in "${PROJECTS[@]}"; do
    if ! build_project "$project"; then
      failed_projects+=("$project")
    fi
    echo ""
  done

  # Copier les builds
  log_info "📋 Copie des fichiers buildés..."
  echo ""
  
  for project in "${PROJECTS[@]}"; do
    if ! [[ " ${failed_projects[@]} " =~ " ${project} " ]]; then
      if ! copy_build "$project"; then
        failed_projects+=("$project")
      fi
    fi
  done
  
  echo ""

  # Créer la page d'accueil
  log_info "🏠 Création de la page d'accueil..."
  create_index
  echo ""

  # Résumé final
  echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
  if [ ${#failed_projects[@]} -eq 0 ]; then
    echo -e "${GREEN}║          ✓ Déploiement réussi !                      ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║  Les fichiers sont prêts dans: ${DEPLOY_DIR}${NC}"
    echo -e "${BLUE}║  Vous pouvez les pousser vers gh-pages                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    exit 0
  else
    echo -e "${RED}║          ✗ Certains projets ont échoué               ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    for project in "${failed_projects[@]}"; do
      echo -e "${RED}║  - ${project}${NC}"
    done
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    exit 1
  fi
}

# Lancer le script
main
