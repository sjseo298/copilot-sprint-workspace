#!/bin/bash
# setup_secrets.sh — Configura las variables de entorno para Azure DevOps MCP.
# Guarda AZURE_DEVOPS_PAT y AZURE_DEVOPS_ORGANIZATION en ~/.bashrc de forma idempotente.
# La organización se puede pre-rellenar desde config/active-profile.json si existe.

set -e

RC_FILE="$HOME/.bashrc"
VAR_PAT="AZURE_DEVOPS_PAT"
VAR_ORG="AZURE_DEVOPS_ORGANIZATION"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ACTIVE_PROFILE="$REPO_ROOT/config/active-profile.json"

echo "Configuración de secretos para Azure DevOps MCP"
echo "------------------------------------------------"

# Pre-rellenar organización desde el perfil activo si disponible
DEFAULT_ORG=""
if [ -f "$ACTIVE_PROFILE" ] && command -v jq >/dev/null 2>&1; then
  DEFAULT_ORG=$(jq -r '.ado.organization // ""' "$ACTIVE_PROFILE" 2>/dev/null)
fi

# Función para actualizar variable en el RC file
update_variable() {
  local var_name="$1"
  local var_value="$2"
  if grep -q "export $var_name=" "$RC_FILE"; then
    sed -i "/export $var_name=/d" "$RC_FILE"
    echo "🔄 Configuración anterior de $var_name actualizada."
  fi
  echo "export $var_name=\"$var_value\"" >> "$RC_FILE"
  echo "✅ $var_name guardado exitosamente."
}

# ─── AZURE_DEVOPS_PAT ─────────────────────────────────────────────────────────
if grep -q "export $VAR_PAT=" "$RC_FILE" 2>/dev/null; then
  echo "⚠️  $VAR_PAT ya está configurado."
  read -rp "¿Deseas sobrescribirlo? (s/N): " response
  if [[ "$response" =~ ^[sS]$ ]]; then
    read -rsp "Ingresa tu Azure DevOps PAT (Personal Access Token): " PAT_INPUT
    echo ""
    [ -n "$PAT_INPUT" ] && update_variable "$VAR_PAT" "$PAT_INPUT"
  fi
else
  read -rsp "Ingresa tu Azure DevOps PAT (Personal Access Token): " PAT_INPUT
  echo ""
  if [ -n "$PAT_INPUT" ]; then
    update_variable "$VAR_PAT" "$PAT_INPUT"
  else
    echo "❌ Token vacío, saltando."
  fi
fi

# ─── AZURE_DEVOPS_ORGANIZATION ───────────────────────────────────────────────
echo ""
PROMPT_ORG="Ingresa la URL de tu organización ADO"
[ -n "$DEFAULT_ORG" ] && PROMPT_ORG="$PROMPT_ORG [$DEFAULT_ORG]"
PROMPT_ORG="$PROMPT_ORG: "

if grep -q "export $VAR_ORG=" "$RC_FILE" 2>/dev/null; then
  echo "⚠️  $VAR_ORG ya está configurado."
  read -rp "¿Deseas sobrescribirlo? (s/N): " response
  if [[ "$response" =~ ^[sS]$ ]]; then
    read -rp "$PROMPT_ORG" ORG_INPUT
    ORG_INPUT="${ORG_INPUT:-$DEFAULT_ORG}"
    [ -n "$ORG_INPUT" ] && update_variable "$VAR_ORG" "$ORG_INPUT" || echo "❌ Organización vacía, no se actualizó."
  fi
else
  read -rp "$PROMPT_ORG" ORG_INPUT
  ORG_INPUT="${ORG_INPUT:-$DEFAULT_ORG}"
  if [ -n "$ORG_INPUT" ]; then
    update_variable "$VAR_ORG" "$ORG_INPUT"
  else
    echo "❌ Organización vacía, saltando."
  fi
fi

echo ""
echo "IMPORTANTE: Ejecuta 'source $RC_FILE' o abre una nueva terminal para aplicar los cambios."
echo "Tip: El MCP server también puede leer PAT e ORGANIZATION desde variables de entorno."
