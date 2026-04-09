#!/usr/bin/env bash
# init.sh — Asistente de configuración inicial del workspace
# Crea config/active-profile.json y config/active-workflow.json interactivamente.
# Se puede re-ejecutar para cambiar el perfil activo en cualquier momento.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$WORKSPACE_ROOT/config"
PROFILES_DIR="$CONFIG_DIR/profiles"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     copilot-sprint-workspace — setup     ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# ─── Listar perfiles disponibles ──────────────────────────────────────────────
PROFILES=$(find "$PROFILES_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
if [[ -z "$PROFILES" ]]; then
  echo -e "${RED}No se encontraron perfiles en $PROFILES_DIR${NC}"
  echo "Crea al menos una carpeta con profile.json para continuar."
  exit 1
fi

echo -e "${BLUE}Perfiles disponibles:${NC}"
i=1
declare -a PROFILE_NAMES
while IFS= read -r profile_dir; do
  name=$(basename "$profile_dir")
  display_name=$(jq -r '.teamName // .name // .id // "'"$name"'"' "$profile_dir/profile.json" 2>/dev/null || echo "$name")
  echo "  [$i] $display_name  (id: $name)"
  PROFILE_NAMES+=("$name")
  ((i++))
done <<< "$PROFILES"

echo ""
read -rp "Selecciona el número de perfil (1-$((i-1))): " SELECTION

if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [[ "$SELECTION" -lt 1 ]] || [[ "$SELECTION" -gt $((i-1)) ]]; then
  echo -e "${RED}Selección inválida.${NC}"
  exit 1
fi

SELECTED_PROFILE="${PROFILE_NAMES[$((SELECTION-1))]}"
PROFILE_DIR="$PROFILES_DIR/$SELECTED_PROFILE"

echo ""
echo -e "${GREEN}Perfil seleccionado: $SELECTED_PROFILE${NC}"

# ─── Datos del usuario ────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Configuración del usuario:${NC}"

read -rp "  Nombre completo: " USER_NAME
read -rp "  Email (Azure DevOps): " USER_EMAIL

# ─── Datos de Azure DevOps ───────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}Configuración de Azure DevOps:${NC}"

DEFAULT_ORG=$(jq -r '.ado.organization // ""' "$PROFILE_DIR/profile.json" 2>/dev/null)
read -rp "  Organización [${DEFAULT_ORG:-tu-organizacion}]: " ADO_ORG
ADO_ORG="${ADO_ORG:-$DEFAULT_ORG}"

DEFAULT_PROJECT=$(jq -r '.ado.project // ""' "$PROFILE_DIR/profile.json" 2>/dev/null)
read -rp "  Proyecto [${DEFAULT_PROJECT:-tu-proyecto}]: " ADO_PROJECT
ADO_PROJECT="${ADO_PROJECT:-$DEFAULT_PROJECT}"

DEFAULT_TEAM=$(jq -r '.ado.team // ""' "$PROFILE_DIR/profile.json" 2>/dev/null)
read -rp "  Equipo [${DEFAULT_TEAM:-tu-equipo}]: " ADO_TEAM
ADO_TEAM="${ADO_TEAM:-$DEFAULT_TEAM}"

# ─── Zona horaria ─────────────────────────────────────────────────────────────
DEFAULT_TZ=$(jq -r '.timezone // "America/Bogota"' "$PROFILE_DIR/profile.json" 2>/dev/null)
read -rp "  Zona horaria [${DEFAULT_TZ}]: " USER_TZ
USER_TZ="${USER_TZ:-$DEFAULT_TZ}"

# ─── Rol del usuario ─────────────────────────────────────────────────────────
DEFAULT_ROLE=$(jq -r '.userRole // "both"' "$PROFILE_DIR/profile.json" 2>/dev/null)
echo ""
echo -e "${YELLOW}Rol del usuario:${NC}"
echo "  [1] creator   — Crea y planifica work items, no necesariamente ejecuta"
echo "  [2] developer — Ejecuta tareas, gestiona evidencias"
echo "  [3] both      — Crea y ejecuta (por defecto)"
read -rp "  Selecciona rol [${DEFAULT_ROLE}]: " ROLE_SELECTION
case "$ROLE_SELECTION" in
  1) USER_ROLE="creator" ;;
  2) USER_ROLE="developer" ;;
  3) USER_ROLE="both" ;;
  *) USER_ROLE="${DEFAULT_ROLE}" ;;
esac

# ─── Construir active-profile.json ───────────────────────────────────────────
cat "$PROFILE_DIR/profile.json" | \
  jq --arg name "$USER_NAME" \
     --arg email "$USER_EMAIL" \
     --arg org "$ADO_ORG" \
     --arg project "$ADO_PROJECT" \
     --arg team "$ADO_TEAM" \
     --arg tz "$USER_TZ" \
     --arg role "$USER_ROLE" \
     --arg profileId "$SELECTED_PROFILE" \
  '.user.name = $name |
   .user.email = $email |
   .ado.organization = $org |
   .ado.project = $project |
   .ado.team = $team |
   .timezone = $tz |
   .userRole = $role |
   ._profileId = $profileId' \
  > "$CONFIG_DIR/active-profile.json"

# ─── Copiar active-workflow.json ─────────────────────────────────────────────
cp "$PROFILE_DIR/workflow.json" "$CONFIG_DIR/active-workflow.json"

echo ""
echo -e "${GREEN}✅ Configuración guardada:${NC}"
echo "   config/active-profile.json"
echo "   config/active-workflow.json"
echo ""
echo -e "${CYAN}Para cambiar de perfil: scripts/switch-team.sh${NC}"
echo -e "${CYAN}Para configurar secretos ADO: scripts/setup_secrets.sh${NC}"
echo ""
