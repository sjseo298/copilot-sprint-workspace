#!/bin/bash

# Configurar codificación UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Script utilitario para preparar evidencias para adjuntar a work items en Azure DevOps.
# Lee el proyecto desde config/active-profile.json automáticamente.
# Uso: ./attach-evidence.sh <workItemId> <archivo_evidencia> [--print-inline]

set -euo pipefail

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ─── Argumentos ───────────────────────────────────────────────────────────────
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo -e "${RED}Error: Uso: $0 <workItemId> <archivo_evidencia> [--print-inline]${NC}"
  exit 1
fi

WORK_ITEM_ID="$1"
EVIDENCE_FILE="$2"
PRINT_INLINE=0
if [ "${3:-}" = "--print-inline" ]; then
  PRINT_INLINE=1
fi

# ─── Validaciones básicas ─────────────────────────────────────────────────────
if [ ! -f "$EVIDENCE_FILE" ]; then
  echo -e "${RED}Error: El archivo '$EVIDENCE_FILE' no existe${NC}"
  exit 1
fi

if ! [[ "$WORK_ITEM_ID" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}Error: workItemId debe ser numérico${NC}"
  exit 1
fi

# ─── Leer proyecto desde config activo ───────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ACTIVE_PROFILE="$REPO_ROOT/config/active-profile.json"

ADO_PROJECT=""
if [ -f "$ACTIVE_PROFILE" ] && command -v jq >/dev/null 2>&1; then
  ADO_PROJECT=$(jq -r '.ado.project // ""' "$ACTIVE_PROFILE" 2>/dev/null)
fi

if [ -z "$ADO_PROJECT" ]; then
  echo -e "${YELLOW}Advertencia: No se pudo leer ado.project desde active-profile.json${NC}"
  read -rp "Ingresa el nombre del proyecto Azure DevOps: " ADO_PROJECT
fi

# ─── Dependencias ────────────────────────────────────────────────────────────
command -v zip >/dev/null 2>&1 || { echo -e "${RED}Error: 'zip' no está instalado${NC}"; exit 1; }
command -v base64 >/dev/null 2>&1 || { echo -e "${RED}Error: 'base64' no está instalado${NC}"; exit 1; }

# ─── Generar artefactos ───────────────────────────────────────────────────────
OUT_DIR="$REPO_ROOT/tmp/attachments/$WORK_ITEM_ID"
mkdir -p "$OUT_DIR"

ZIP_FILENAME="$(basename "$EVIDENCE_FILE" .md).zip"
ZIP_FILE="$OUT_DIR/$ZIP_FILENAME"
BASE64_FILE="$OUT_DIR/$ZIP_FILENAME.b64"
DATAURL_FILE="$OUT_DIR/$ZIP_FILENAME.dataurl"

cd "$(dirname "$EVIDENCE_FILE")"
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 zip -q "$ZIP_FILE" "$(basename "$EVIDENCE_FILE")" 2>/dev/null
cd - > /dev/null

ORIGINAL_SIZE=$(wc -c < "$EVIDENCE_FILE")
ZIP_SIZE=$(wc -c < "$ZIP_FILE")
COMPRESSION_RATIO=$((100 - (ZIP_SIZE * 100 / ORIGINAL_SIZE)))

LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 base64 -w 0 "$ZIP_FILE" > "$BASE64_FILE"
echo -n "data:application/zip;base64," > "$DATAURL_FILE"
cat "$BASE64_FILE" >> "$DATAURL_FILE"

# ─── Output ───────────────────────────────────────────────────────────────────
echo -e "${GREEN}✅ Compresión: ${COMPRESSION_RATIO}%${NC} (${ORIGINAL_SIZE} → ${ZIP_SIZE} bytes)"
if command -v sha256sum >/dev/null 2>&1; then
  echo -e "${GREEN}🔐 SHA256:${NC} $(sha256sum "$ZIP_FILE" | awk '{print $1}')"
fi
echo ""
echo -e "${YELLOW}📦 Artefactos:${NC}"
echo "  ZIP:      $ZIP_FILE"
echo "  Base64:   $BASE64_FILE"
echo "  DataURL:  $DATAURL_FILE"
echo ""
echo -e "${YELLOW}💡 Comando MCP sugerido (usa el contenido del archivo .dataurl):${NC}"
echo -e "${GREEN}mcp_spring-mcp-se_azuredevops_wit_attachments${NC}"
echo "  operation: \"add_to_work_item\""
echo "  project: \"$ADO_PROJECT\""
echo "  workItemId: $WORK_ITEM_ID"
echo "  dataUrl: \"<pega-aquí-el-contenido-de: $DATAURL_FILE>\""
echo "  fileName: \"$ZIP_FILENAME\""
echo "  contentType: \"application/zip\""
echo "  comment: \"Evidencia del trabajo completado\""

if [ "$PRINT_INLINE" -eq 1 ]; then
  echo ""
  echo -e "${YELLOW}⚠️ Modo --print-inline: imprimiendo dataUrl inline (puede truncarse en algunas UIs).${NC}"
  echo -e "${GREEN}mcp_spring-mcp-se_azuredevops_wit_attachments${NC}"
  echo "  operation: \"add_to_work_item\""
  echo "  project: \"$ADO_PROJECT\""
  echo "  workItemId: $WORK_ITEM_ID"
  echo "  dataUrl: \"data:application/zip;base64,$(cat "$BASE64_FILE")\""
  echo "  fileName: \"$ZIP_FILENAME\""
  echo "  contentType: \"application/zip\""
  echo "  comment: \"Evidencia del trabajo completado\""
fi
