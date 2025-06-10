#!/bin/bash

# release.sh - Script de release amélioré avec standard-version
set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
DRY_RUN=false
RELEASE_TYPE=""
FORCE=false
SKIP_TESTS=false

# Fonction d'aide
show_help() {
    cat << EOF
${BLUE}Script de Release - Task Management System${NC}

Usage: $0 [OPTIONS]

Options:
    -t, --type TYPE         Type de release (patch, minor, major, prerelease)
    -d, --dry-run           Simule la release sans l'exécuter
    -f, --force             Force la release même si des tests échouent
    -s, --skip-tests        Ignore les tests
    -h, --help              Affiche cette aide

Types de release:
    patch       Corrections de bugs (1.0.0 -> 1.0.1)
    minor       Nouvelles fonctionnalités (1.0.0 -> 1.1.0)
    major       Changements incompatibles (1.0.0 -> 2.0.0)
    prerelease  Version pré-release (1.0.0 -> 1.0.1-0)

Exemples:
    $0                          # Release automatique basée sur les commits
    $0 --type patch             # Release patch
    $0 --type minor --dry-run   # Simule une release minor
    $0 --force                  # Force la release même si tests échouent

EOF
}

# Fonction de logging
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Vérifications préliminaires
check_prerequisites() {
    log "🔍 Vérification des prérequis..."
    
    # Vérifier si on est dans un repo git
    if [ ! -d ".git" ]; then
        error "Ce script doit être exécuté dans un dépôt Git"
    fi
    
    # Vérifier si package.json existe
    if [ ! -f "package.json" ]; then
        error "package.json non trouvé"
    fi
    
    # Vérifier si standard-version est installé
    if ! npm list standard-version > /dev/null 2>&1; then
        error "standard-version n'est pas installé. Exécutez: npm install --save-dev standard-version"
    fi
    
    # Vérifier la branche actuelle
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "master" ] && [ "$CURRENT_BRANCH" != "main" ]; then
        if [ "$FORCE" != "true" ]; then
            error "Vous devez être sur la branche master/main pour faire une release. Branche actuelle: $CURRENT_BRANCH"
        else
            warning "Release sur la branche $CURRENT_BRANCH (--force activé)"
        fi
    fi
    
    # Vérifier l'état du working directory
    if [ -n "$(git status --porcelain)" ]; then
        if [ "$FORCE" != "true" ]; then
            error "Le working directory n'est pas propre. Committez ou stashez vos changements"
        else
            warning "Working directory pas propre mais release forcée"
        fi
    fi
    
    # Vérifier si on est à jour avec origin
    git fetch origin
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/$CURRENT_BRANCH 2>/dev/null || echo "")
    
    if [ -n "$REMOTE" ] && [ "$LOCAL" != "$REMOTE" ]; then
        if [ "$FORCE" != "true" ]; then
            error "Votre branche locale n'est pas à jour avec origin. Exécutez: git pull"
        else
            warning "Branche locale pas à jour avec origin (--force activé)"
        fi
    fi
    
    log "✅ Prérequis validés"
}

# Exécuter les tests
run_tests() {
    if [ "$SKIP_TESTS" == "true" ]; then
        warning "Tests ignorés (--skip-tests)"
        return
    fi
    
    log "🧪 Exécution des tests..."
    
    if [ "$DRY_RUN" == "true" ]; then
        info "DRY RUN: npm test"
        return
    fi
    
    if ! npm test; then
        if [ "$FORCE" != "true" ]; then
            error "Les tests ont échoué. Utilisez --force pour ignorer ou --skip-tests pour les ignorer"
        else
            warning "Tests échoués mais release forcée"
        fi
    fi
    
    log "✅ Tests passés"
}

# Obtenir la version actuelle
get_current_version() {
    node -p "require('./package.json').version"
}

# Exécuter standard-version
run_standard_version() {
    local current_version=$(get_current_version)
    log "📦 Version actuelle: $current_version"
    
    # Configuration Git pour standard-version
    git config user.name "Release Script" 2>/dev/null || true
    git config user.email "release@task-management-system.local" 2>/dev/null || true
    
    # Construire la commande standard-version
    local cmd="npx standard-version"
    
    if [ -n "$RELEASE_TYPE" ]; then
        case $RELEASE_TYPE in
            "prerelease")
                cmd="$cmd --prerelease"
                ;;
            "patch"|"minor"|"major")
                cmd="$cmd --release-as $RELEASE_TYPE"
                ;;
            *)
                error "Type de release invalide: $RELEASE_TYPE"
                ;;
        esac
    fi
    
    if [ "$DRY_RUN" == "true" ]; then
        cmd="$cmd --dry-run"
    fi
    
    log "🚀 Exécution de standard-version..."
    info "Commande: $cmd"
    
    # Exécuter standard-version
    if eval "$cmd"; then
        if [ "$DRY_RUN" != "true" ]; then
            local new_version=$(get_current_version)
            log "✅ Release créée: $current_version -> $new_version"
            
            # Afficher les fichiers modifiés
            info "Fichiers modifiés:"
            git diff --name-only HEAD~1 HEAD | sed 's/^/  - /'
            
            return 0
        else
            log "✅ Simulation de release terminée"
            return 0
        fi
    else
        error "Échec de standard-version"
    fi
}

# Pousser les changements
push_changes() {
    if [ "$DRY_RUN" == "true" ]; then
        info "DRY RUN: git push origin $(git branch --show-current) --follow-tags"
        return
    fi
    
    log "📤 Push des changements et tags..."
    
    if git push origin $(git branch --show-current) --follow-tags; then
        log "✅ Changements poussés vers origin"
        
        local new_version=$(get_current_version)
        local repo_url=$(git remote get-url origin | sed 's/\.git$//')
        
        info "🎉 Release v$new_version créée avec succès!"
        info "🔗 Voir sur GitHub: $repo_url/releases/tag/v$new_version"
        info "📝 CHANGELOG.md et package.json ont été mis à jour automatiquement"
    else
        error "Échec du push vers origin"
    fi
}

# Fonction principale
main() {
    log "🚀 Début de la release Task Management System"
    
    check_prerequisites
    run_tests
    run_standard_version
    push_changes
    
    log "🎉 Release terminée avec succès!"
}

# Parse des arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            RELEASE_TYPE="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -s|--skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            error "Argument inconnu: $1. Utilisez --help pour voir l'aide"
            ;;
    esac
done

# Exécuter le script principal
main