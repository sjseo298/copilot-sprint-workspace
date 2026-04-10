# Instrucciones del Workspace — Copilot Sprint Manager

## Primer uso — configuración obligatoria

Si `config/active-profile.json` **no existe**, este workspace NO está configurado.
Antes de cualquier otra acción, indica al usuario:

> "Este workspace no está configurado todavía. Usa el agente **@setup-wizard** para
> conectar tu proyecto de Azure DevOps y crear tu perfil de equipo.
> Solo toma unos minutos y lo configura todo automáticamente."

## Uso diario — una vez configurado

Cuando `config/active-profile.json` **existe**, lee siempre estos archivos al inicio de cada conversación:

1. `config/active-profile.json` — identidad del usuario, proyecto ADO, equipo, zona horaria, rol
2. `config/active-workflow.json` — tipos de work items, estados válidos, campos obligatorios

Con esa información activa, los agentes disponibles son:

| Agente | Propósito | Cuándo usar |
|--------|-----------|-------------|
| `@setup-wizard` | Configuración inicial o cambio de perfil | Primera vez o cambio de equipo |
| `@sprint-manager` | Estado del sprint, sincronización ADO↔local, plan del día | Cada mañana |
| `@work-item-creator` | Crear Features, Tareas y Subtareas con todos los campos | Al iniciar nueva historia |
| `@task-closer` | Cerrar work items con evidencias y comentario de cierre | Al terminar trabajo |

## Reglas generales (aplican siempre)

- **Zona horaria**: usar siempre la de `active-profile.json > timezone`. No asumir UTC.
- **Campos Custom**: los GUIDs de campos custom y sus valores válidos están en `active-workflow.json`. Nunca usar valores fuera de las picklists cerradas.
- **Estados**: solo los listados en `active-workflow.json > states`. Nunca usar "Closed", "Done" u otros en inglés salvo que el workflow lo defina explícitamente.
- **Evidencias**: toda Subtarea cerrada requiere un archivo `*_evidencia.md` con contenido real en su carpeta `tasks/`.
- **Comentarios en ADO**: usar HTML (no Markdown). Ver `.github/instructions/azure-devops-markdown-formatting.instructions.md`.
- **Work items sensibles**: no incluir `[System.Description]`, `[AcceptanceCriteria]` ni `[System.History]` en queries WIQL masivos.
- **Idioma**: responder siempre en español salvo que el perfil indique otro idioma.

## Sobre los prompts disponibles

Los siguientes prompts reutilizables están en `.github/prompts/`:

- `inicio_dia` — resumen del sprint y plan de trabajo
- `query-sprint` — consulta WIQL del sprint activo
- `create-evidence` — genera archivo de evidencia para una subtarea
- `sprint-retrospective` — análisis de velocidad y aprendizajes del sprint
