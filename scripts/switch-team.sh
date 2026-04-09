#!/usr/bin/env bash
# switch-team.sh — Cambia el perfil activo sin re-configurar todo.
# Útil cuando trabajas en múltiples proyectos/equipos.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$WORKSPACE_ROOT/config"
PROFILES_DIR="$CONFIG_DIR/profiles"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Si se pasa el nombre del perfil como argumento, usarlo directamente
if [[ -n "$1" ]]; then
  TARGET_PROFILE="$1"
  if [[ ! -d "$PROFILES_DIR/$TARGET_PROFILE" ]]; then
    echo -e "${RED}Perfil '$TARGET_PROFILE' no encontrado en $PROFILES_DIR${NC}"
    exit 1
  fi
else
  # Listar perfiles disponibles
  PROFILES=$(find "$PROFILES_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
  if [[ -z "$PROFILES" ]]; then
    echo -e "${RED}No se encontraron perfiles en $PROFILES_DIR${NC}"
    exit 1
  fi

  echo ""
  echo -e "${BLUE}Perfiles disponibles:${NC}"
  i=1
  declare -a PROFILE_NAMES
  while IFS= read -r profile_dir; do
    name=$(basename "$profile_dir")
    display_name=$(jq -r '.teamName // .name // .id // "'"$name"'"' "$profile_dir/profile.json" 2>/dev/null || echo "$name")
    # Marcar el activo
    current_profile=$(jq -r '._profileId // ""' "$CONFIG_DIR/active-profile.json" 2>/dev/null)
    marker=""
    [[ "$name" == "$current_profile" ]] && marker=" ${GREEN}← activo${NC}"
    echo -e "  [$i] $display_name  (id: $name)$marker"
    PROFILE_NAMES+=("$name")
    ((i++))
  done <<< "$PROFILES"

  echo ""
  read -rp "Selecciona el número de perfil: " SELECTION
  if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [[ "$SELECTION" -lt 1 ]] || [[ "$SELECTION" -gt $((i-1)) ]]; then
    echo -e "${RED}Selección inválida.${NC}"
    exit 1
  fi
  TARGET_PROFILE="${PROFILE_NAMES[$((SELECTION-1))]}"
fi

PROFILE_DIR="$PROFILES_DIR/$TARGET_PROFILE"

# Combinar datos de usuario del perfil activo con la nueva configuración
if [[ -f "$CONFIG_DIR/active-profile.json" ]]; then
  CURRENT_USER=$(jq '.user' "$CONFIG_DIR/active-profile.json" 2>/dev/null)
else
  CURRENT_USER='{"name": "", "email": ""}'
fi

# Actualizar active-profile.json manteniendo datos del usuario
jq --argjson user "$CURRENT_USER" \
   --arg profileId "$TARGET_PROFILE" \
   '.user = $user | ._profileId = $profileId' \
   "$PROFILE_DIR/profile.json" \
   > "$CONFIG_DIR/active-profile.json"

# Actualizar active-workflow.json
cp "$PROFILE_DIR/workflow.json" "$CONFIG_DIR/active-workflow.json"

echo ""
echo -e "${GREEN}✅ Perfil cambiado a: $TARGET_PROFILE${NC}"
echo "   config/active-profile.json"
echo "   config/active-workflow.json"
echo ""
echo -e "${CYAN}Tip: Si el usuario cambió, ejecuta scripts/init.sh para actualizar todos los datos.${NC}"
echo ""
