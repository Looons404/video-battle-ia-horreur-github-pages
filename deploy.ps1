# ========================================
# Script de déploiement GitHub Pages (Windows PowerShell)
# Monorepo: ChatGPT vs Claude vs Composer vs Gemini
# ========================================

param(
    [switch]$Clean = $false
)

# Variables
$PROJECTS = @("chatgpt", "claude", "composer", "gemini")
$DEPLOY_DIR = "dist"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Fonctions
function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Build-Project {
    param([string]$Project)
    
    $projectPath = ".\$Project"
    
    if (-not (Test-Path $projectPath)) {
        Write-Error-Custom "Le dossier $Project n'existe pas"
        return $false
    }
    
    Write-Info "📦 Construction de $Project..."
    
    Push-Location $projectPath
    
    if (Test-Path "package.json") {
        Write-Info "  → Installation des dépendances..."
        npm install
        
        Write-Info "  → Build du projet..."
        npm run build
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "  → $Project construit avec succès"
            Pop-Location
            return $true
        } else {
            Write-Error-Custom "  → Erreur lors du build de $Project"
            Pop-Location
            return $false
        }
    } else {
        Write-Error-Custom "  → Pas de package.json trouvé dans $Project"
        Pop-Location
        return $false
    }
}

function Copy-Build {
    param([string]$Project)
    
    $source = ".\$Project\dist"
    $destination = ".\$DEPLOY_DIR\$Project"
    
    if (-not (Test-Path $source)) {
        Write-Error-Custom "Pas de dossier dist trouvé pour $Project"
        return $false
    }
    
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Copy-Item "$source\*" $destination -Recurse -Force
    Write-Success "Fichiers de $Project copiés vers $destination"
    return $true
}

function Create-Index {
    $content = @'
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
        <p>Projet créé par <a href="https://www.youtube.com/@AywenVideos" target="_blank">Aywen</a></p>
        <p>Effets sonores provenant de <a href="https://pixabay.com/fr/sound-effects/" target="_blank">Pixabay</a></p>
        <p style="margin-top: 20px; color: #505050;">⚠️ Code fourni à titre éducatif et expérimental</p>
      </div>
    </footer>
  </div>
</body>
</html>
'@
    
    $content | Out-File -FilePath ".\$DEPLOY_DIR\index.html" -Encoding UTF8
    Write-Success "Page d'accueil créée"
}

# Main
function Main {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║   Déploiement GitHub Pages - Monorepo Jeux d'Horreur   ║" -ForegroundColor Blue
    Write-Host "║                    $TIMESTAMP                   ║" -ForegroundColor Blue
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
    
    # Vérifier que nous sommes à la racine du monorepo
    if (-not (Test-Path "README.md")) {
        Write-Error-Custom "Vous devez exécuter ce script à la racine du monorepo"
        exit 1
    }
    
    # Nettoyer le dossier de déploiement
    if (Test-Path $DEPLOY_DIR) {
        if ($Clean) {
            Write-Warning "Suppression du dossier $DEPLOY_DIR existant..."
            Remove-Item $DEPLOY_DIR -Recurse -Force
        }
    }
    
    New-Item -ItemType Directory -Path $DEPLOY_DIR -Force | Out-Null
    Write-Success "Dossier de déploiement créé: $DEPLOY_DIR"
    Write-Host ""
    
    # Construire tous les projets
    $failedProjects = @()
    
    foreach ($project in $PROJECTS) {
        if (-not (Build-Project $project)) {
            $failedProjects += $project
        }
        Write-Host ""
    }
    
    # Copier les builds
    Write-Info "📋 Copie des fichiers buildés..."
    Write-Host ""
    
    foreach ($project in $PROJECTS) {
        if ($failedProjects -notcontains $project) {
            if (-not (Copy-Build $project)) {
                $failedProjects += $project
            }
        }
    }
    
    Write-Host ""
    
    # Créer la page d'accueil
    Write-Info "🏠 Création de la page d'accueil..."
    Create-Index
    Write-Host ""
    
    # Résumé final
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    if ($failedProjects.Count -eq 0) {
        Write-Host "║          ✓ Déploiement réussi !                      ║" -ForegroundColor Green
        Write-Host "║                                                        ║" -ForegroundColor Blue
        Write-Host "║  Les fichiers sont prêts dans: $DEPLOY_DIR${' ' * (35 - $DEPLOY_DIR.Length)}║" -ForegroundColor Blue
        Write-Host "║  Vous pouvez les pousser vers gh-pages                ║" -ForegroundColor Blue
        Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Blue
        exit 0
    } else {
        Write-Host "║          ✗ Certains projets ont échoué               ║" -ForegroundColor Red
        Write-Host "║                                                        ║" -ForegroundColor Blue
        foreach ($project in $failedProjects) {
            Write-Host "║  - $project${' ' * (48 - $project.Length)}║" -ForegroundColor Red
        }
        Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Blue
        exit 1
    }
}

# Exécuter
Main
