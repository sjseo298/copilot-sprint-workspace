# copilot-sprint-workspace

> Template de workspace para gestión de sprints con **GitHub Copilot + Azure DevOps MCP**.

Permite gestionar el ciclo completo de un sprint (planificación, ejecución, cierre, evidencias) directamente desde VS Code con asistencia IA, conectado a Azure DevOps a través de un servidor MCP.

## Características

- **Multi-perfil**: Soporte para múltiples equipos/proyectos con cambio de contexto instantáneo
- **MCP integrado**: Conecta con Azure DevOps via Docker, Podman o JAR (sin extensiones extra)
- **Agentes especializados**: Setup wizard, creador de work items, gestor de sprint, cierre guiado
- **Evidencias trazables**: Convención de carpetas y archivos para documentar el trabajo realizado
- **Roles de usuario**: `creator` (planifica) / `developer` (ejecuta) / `both`
- **100% local**: Sin servidor propio, sin datos en la nube — todo corre en tu máquina

## Inicio rápido

### 1. Usar este template
```bash
# En GitHub: "Use this template" → "Create a new repository"
# Luego clona tu nuevo repo:
git clone https://github.com/<tu-usuario>/<tu-repo>.git
cd <tu-repo>
```

### 2. Configurar el workspace
```bash
bash scripts/init.sh
```
El wizard interactivo te guiará por los 6 pasos de configuración.

**O usa el agente de Copilot:**
```
@setup-wizard Configura el workspace para mi equipo
```

### 3. Configurar secretos de Azure DevOps
```bash
bash scripts/setup_secrets.sh
```
Necesitas un [Personal Access Token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) con permisos de lectura/escritura en Work Items.

### 4. Empezar el día
```
@inicio_dia
```

## Estructura del workspace

```
copilot-sprint-workspace/
├── config/
│   ├── profiles/                 # Perfiles de equipo disponibles
│   │   ├── default.profile.json  # Template para nuevo perfil
│   │   ├── tam-example/          # Ejemplo: equipo de arquitectura
│   │   └── dev-team-example/     # Ejemplo: equipo de desarrollo
│   ├── active-profile.json       # ← Perfil activo (gitignored)
│   └── active-workflow.json      # ← Workflow activo (gitignored)
├── tasks/                        # Carpetas de trabajo por tarea
│   └── EXAMPLE-001 - .../        # Ejemplo de estructura
├── scripts/
│   ├── init.sh                   # Configuración inicial interactiva
│   ├── switch-team.sh            # Cambiar perfil activo
│   ├── setup_secrets.sh          # Configurar PAT y org ADO
│   └── attach-evidence.sh        # Comprimir y adjuntar evidencias
├── .github/
│   ├── instructions/             # Instrucciones para GitHub Copilot
│   ├── prompts/                  # Prompts reutilizables
│   ├── setup-wizard.agent.md     # Agente: configuración inicial
│   ├── sprint-manager.agent.md   # Agente: gestión del sprint
│   ├── work-item-creator.agent.md # Agente: crear work items
│   └── task-closer.agent.md      # Agente: cerrar work items
├── .vscode/
│   ├── mcp.json                  # Configuración del MCP Server
│   └── extensions.json           # Extensiones recomendadas
├── restricciones_sprint.template # Template para restricciones de sprint
└── README_sprint_TEMPLATE.md     # Template para README de sprint
```

## Opciones de MCP Server

El servidor MCP `sjseo298/mcp-azure-devops` puede desplegarse de 3 formas:

| Modo | Requisito | Configuración |
|------|-----------|---------------|
| `docker` | Docker Desktop | `command: "docker"` |
| `podman` | Podman CLI | `command: "podman"` |
| `jar` | Java 17+ | `command: "java"`, JAR en `tools/` |

El wizard configura `.vscode/mcp.json` automáticamente según tu elección.
Para el modo JAR, descarga la última versión desde:
[github.com/sjseo298/AzureDevopsCompanionMCP/releases](https://github.com/sjseo298/AzureDevopsCompanionMCP/releases)

## Perfiles de equipo

Cada perfil en `config/profiles/<nombre>/` contiene:
- `profile.json` — Identidad del equipo, datos ADO, capacidad del sprint
- `workflow.json` — Tipos de work item, estados, campos obligatorios, actividades
- `field-catalog.md` — Documentación humana de los campos
- `custom-context.md` — Narrativa y contexto específico del equipo

Para crear un nuevo perfil:
```bash
cp -r config/profiles/default.profile.json config/profiles/mi-equipo/profile.json
# Editar los archivos según tu equipo
bash scripts/init.sh  # Seleccionar el nuevo perfil
```

## Agentes disponibles

| Agente | Invocación | Uso |
|--------|-----------|-----|
| Setup Wizard | `@setup-wizard` | Configuración inicial o cambio de perfil |
| Sprint Manager | `@sprint-manager` | Estado, plan del día, sincronización |
| Work Item Creator | `@work-item-creator` | Crear features, tareas, subtareas |
| Task Closer | `@task-closer` | Cerrar work items con validación completa |

## Prompts rápidos

| Prompt | Invocación | Uso |
|--------|-----------|-----|
| Inicio día | `@inicio_dia` | Radiografía del sprint + plan del día |
| Query sprint | `@query-sprint` | Tabla rápida de work items activos |
| Crear evidencia | `@create-evidence` | Generar archivo de evidencia de una subtarea |
| Retrospectiva | `@sprint-retrospective` | Análisis del sprint finalizado |

## Seguridad

- El PAT de Azure DevOps se guarda en `~/.bashrc` (variable de entorno), nunca en archivos del repo
- `config/active-profile.json` está en `.gitignore` (contiene email y datos de conexión)
- Los archivos de evidencia son locales y se suben manualmente o via script

## Requisitos

- VS Code con GitHub Copilot
- Acceso a Azure DevOps con PAT
- Una de las siguientes opciones para el MCP: Docker, Podman, o Java 17+

## Licencia

[MIT](LICENSE)
