---
name: create-evidence
description: Crea el archivo de evidencia local para una subtarea completada. Pregunta por el contenido, genera el .md en la carpeta correcta y ofrece adjuntarlo a ADO.
---

Lee `config/active-profile.json` y `config/active-workflow.json`.

## Objetivo
Generar el archivo de evidencia para una subtarea completada, siguiendo la convención de nombres y estructura del workspace.

## Pasos

### 1. Identificar la subtarea
Si el usuario no especificó el ID, lista las subtareas activas en `tasks/` que no tengan aún archivo `*_evidencia.md`.

### 2. Recopilar información del trabajo realizado
Pregunta al usuario:
- ¿Qué se logró exactamente? (entregables, decisiones, resultados)
- ¿Hubo cambios respecto al plan original? (desvíos, descubrimientos)
- ¿Cuántas horas tomó realmente?
- ¿Hay enlaces, comandos o snippets relevantes a documentar?

### 3. Leer el contexto de la subtarea
Si existe `subtasks.json` en la carpeta padre, lee los datos de la subtarea (título, descripción, actividad).

### 4. Generar el archivo
**Nomenclatura**: `subtarea_<workItemId>_<titulo_con_guiones_bajos>_evidencia.md`
**Ubicación**: `tasks/<parentWorkItemId> - <título_tarea>/`

**Estructura del archivo:**
```markdown
# Evidencia: <título de la subtarea>

**Work Item ID**: #<id>
**Fecha**: <fecha actual>
**Horas reales**: <N> h
**Actividad**: <actividad del workflow>

---

## Trabajo Realizado

<descripción detallada del trabajo ejecutado>

## Entregables

- <entregable 1>: <ubicación o descripción>
- <entregable 2>

## Decisiones y Hallazgos

<notas sobre decisiones tomadas, cambios respecto al plan, descubrimientos>

## Comandos / Referencias

```<lenguaje>
<snippets relevantes si aplica>
```

## Validación

<cómo se verificó que el trabajo está correcto>
```

**Antes de crear el archivo, confirma con el usuario el contenido.**

### 5. Ofrecer adjunto a ADO
Después de crear el archivo:
> "¿Quieres adjuntar este archivo al work item en Azure DevOps ahora?
> Opción 1: Ejecutar `scripts/attach-evidence.sh <id> <archivo>` manualmente.
> Opción 2: Yo lo proceso con MCP directamente (requiere leer el archivo y subirlo).
> Opción 3: Lo subes manualmente en Azure DevOps."

Si elige Opción 2, procede con `mcp_spring-mcp-se_azuredevops_wit_attachments`.

### 6. Actualizar subtasks.json
Actualiza el campo `evidenciaFile` y `evidenciaAdjuntada` (true/false) en `subtasks.json`.
