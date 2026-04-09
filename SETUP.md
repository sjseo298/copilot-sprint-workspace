# Guía de Configuración Detallada

Esta guía explica en detalle cada paso de la configuración del workspace.

---

## Paso 1: Entender los perfiles de equipo

Antes de configurar, elige el perfil que mejor se adapta a tu equipo:

```
config/profiles/
├── default.profile.json    ← Template en blanco para empezar
├── tam-example/            ← Equipo de arquitectura (sprint 11 días, Java)
└── dev-team-example/       ← Equipo de desarrollo (sprint 14 días, Epic→Story→Task)
```

Cada perfil tiene 4 archivos:

| Archivo | Descripción |
|---------|-------------|
| `profile.json` | Configuración principal: IDs, capacidad, zona horaria, rol |
| `workflow.json` | Tipos de work item, estados, campos obligatorios, actividades |
| `field-catalog.md` | Referencia humana de todos los campos |
| `custom-context.md` | Narrativa y contexto que Copilot usará para entender tu equipo |

### Crear un perfil nuevo

```bash
mkdir config/profiles/mi-equipo
cp config/profiles/default.profile.json config/profiles/mi-equipo/profile.json
cp config/profiles/tam-example/workflow.json config/profiles/mi-equipo/workflow.json
# Editar ambos archivos con los valores reales de tu equipo
```

---

## Paso 2: Configuración interactiva (recomendada)

```bash
bash scripts/init.sh
```

El script te pedirá:
1. Seleccionar un perfil
2. Tu nombre y email de Azure DevOps
3. Organización, proyecto y equipo de ADO
4. Zona horaria
5. Tu rol (`creator` / `developer` / `both`)

Al finalizar, crea:
- `config/active-profile.json`
- `config/active-workflow.json`

---

## Paso 3: Personal Access Token (PAT)

Ve a Azure DevOps → Configuración de usuario → Personal Access Tokens.

Crea un token con permisos:
- **Work Items**: Read & Write
- **Code**: Read (si el agente necesita analizar repositorios)

Luego ejecuta:
```bash
bash scripts/setup_secrets.sh
```

Esto guarda las variables en `~/.bashrc`:
- `AZURE_DEVOPS_PAT`
- `AZURE_DEVOPS_ORGANIZATION`

Aplica los cambios:
```bash
source ~/.bashrc
```

---

## Paso 4: MCP Server

El MCP Server es el puente entre GitHub Copilot y Azure DevOps.
Usa `sjseo298/mcp-azure-devops`.

### Opción A: Docker (más simple)
```bash
docker pull sjseo298/mcp-azure-devops
```
El `@setup-wizard` configura `.vscode/mcp.json` con el modo `docker`.

### Opción B: Podman (rootless)
```bash
podman pull sjseo298/mcp-azure-devops
```
Selecciona `podman` en el wizard.

### Opción C: JAR (sin contenedor)
1. Descarga el JAR desde [releases](https://github.com/sjseo298/AzureDevopsCompanionMCP/releases)
2. Colócalo en `tools/mcp-azure-devops.jar`
3. Selecciona `jar` en el wizard

Requiere Java 17+: `java -version`

---

## Paso 5: Verificar la conexión

Abre VS Code y prueba con Copilot Chat:
```
Lista mis work items activos de Azure DevOps
```

Si el MCP funciona, Copilot consultará ADO y mostrará los resultados.

---

## Paso 6: Configurar el sprint activo

Crea el archivo `restricciones_sprint` basándote en el template:
```bash
cp restricciones_sprint.template restricciones_sprint
# Editar con las fechas y reuniones de tu sprint actual
```

El `@setup-wizard` también puede guiarte en este paso.

---

## Cambiar de perfil en cualquier momento

```bash
bash scripts/switch-team.sh
```

O desde Copilot:
```
@setup-wizard Quiero cambiar al perfil de mi equipo de desarrollo
```

---

## Estructura de una tarea en el workspace

Cada Tarea de Azure DevOps tiene una carpeta local:

```
tasks/12345 - Mi Tarea/
├── README.md          # Descripción, criterios, progreso
├── task.json          # Metadatos y estado de sincronización
├── subtasks.json      # Array de subtareas con campos ADO
└── subtarea_12345_ST1_titulo_evidencia.md  # Evidencia de trabajo
```

El `@work-item-creator` crea esta estructura automáticamente.

---

## Flujo de trabajo típico

```
Lunes (inicio día)
  → @inicio_dia
  → Revisar tabla comparativa ADO vs local
  → Priorizar según plan sugerido

Durante el día
  → Trabajar en subtareas
  → @create-evidence cuando completes una subtarea

Al cerrar subtareas
  → @task-closer 12345

Fin de sprint
  → @sprint-retrospective
  → Crear restricciones_sprint para el próximo sprint
```

---

## Preguntas frecuentes

**¿Puedo usar este workspace para múltiples sprints?**
Sí. Los archivos `restricciones_sprint` y `README_sprint_*.md` se actualizan por sprint. La carpeta `tasks/` acumula el historial.

**¿Los archivos de evidencia se versionan en git?**
Sí, a diferencia de `active-profile.json` que está en `.gitignore`. El historial de evidencias queda en el repositorio.

**¿Qué pasa si el MCP no funciona?**
Copilot operará sin acceso a ADO. Puedes crear los work items manualmente y luego sincronizarlos con `@sprint-manager sync`.

**¿Cómo contribuyo con mejoras?**
Abre un issue o PR en [github.com/sjseo298/copilot-sprint-workspace](https://github.com/sjseo298/copilot-sprint-workspace).
