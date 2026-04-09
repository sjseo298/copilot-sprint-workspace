---
applyTo: '**'
---
# Instrucciones para manejo de Work Items

> **ANTES DE CUALQUIER OPERACIÓN**: Lee `config/active-profile.json` y `config/active-workflow.json`.
> Todos los valores de proyecto, equipo, estados, campos y jerarquía provienen de esos archivos.
> Nunca hardcodees org, proyecto, equipo ni campos Custom.

## Uso de MCP (Azure DevOps) — resumen (conciso)

- **Consultar (WIQL)**: usar `mcp_spring-mcp-se_azuredevops_wit_queries` con `operation: "wiql_query"` y el campo **`wiql`** (no `query`).
- **WIQL masivo (regla)**: NO incluir `[System.Description]`, `[Microsoft.VSTS.Common.AcceptanceCriteria]`, `[System.History]`.
- **Detalle puntual**: usar `mcp_spring-mcp-se_azuredevops_wit_work_items` con `operation: "get"` (opcional `fields`) y `raw: true` si se requiere texto largo.
- **Crear/actualizar work items**: `mcp_spring-mcp-se_azuredevops_wit_work_items` con `operation: "create"|"update"` (atajos `title/description/state/area/iteration` o patch `add/replace/remove`).
- **Comentarios**: `mcp_spring-mcp-se_azuredevops_wit_comments` con `operation: "add"` y **HTML** (no Markdown).
- **Adjuntos**: `mcp_spring-mcp-se_azuredevops_wit_attachments` con `operation: "add_to_work_item"` usando `filePath` o `dataUrl`.

## 1. Configuración base del proyecto

### Fuente de verdad
Todos los valores se leen desde los archivos de configuración activos:

| Dato | Fuente |
|------|--------|
| Proyecto ADO | `active-profile.json > ado.project` |
| Organización | `active-profile.json > ado.organization` |
| Equipo | `active-profile.json > ado.team` |
| Usuario | `active-profile.json > user.email` |
| Zona horaria | `active-profile.json > timezone` |
| Horas/día | `active-profile.json > workHoursPerDay` |
| Días del sprint | `active-profile.json > sprintDays` |
| Estados activos | `active-workflow.json > states.active` |
| Estado cerrado | `active-workflow.json > states.closed` |
| Tipos de work item | `active-workflow.json > workItemTypes` |
| Campos obligatorios | `active-workflow.json > fields.<Tipo>.required` |
| Campos Custom | `active-workflow.json > fields.<Tipo>.custom` |

### Capacidad del sprint
- **Horas brutas**: `sprintDays * workHoursPerDay`
- **Capacidad real**: Horas brutas menos reuniones fijas y actividades de aprendizaje
- **Restricciones**: ver archivo `restricciones_sprint` en la raíz si existe
- **Documentación del sprint**: ver `README_sprint_*.md` si existe

### Tabla de Capacidad en README
Al crear el README del sprint, incluir tabla de capacidad:
1. **Horas Brutas**: `sprintDays * workHoursPerDay`
2. **Horas Netas**: Horas Brutas - Reuniones Fijas
3. **Horas Capacidad**: Horas Netas - Otras Actividades (Cursos, Imprevistos)
4. **Días Capacidad**: Horas Capacidad / `workHoursPerDay`

**Ejemplo de formato:**
| Horas | Concepto |
|-------|----------|
| | **[Nombre Usuario]** |
| -8 | Curso de formación |
| -7.5 | Imprevistos |
| **52.0** | **Horas Capacidad** |
| **6.1** | **Días Capacidad** |

### Estados oficiales
Los estados válidos se leen desde `active-workflow.json`:
- **Estados activos**: `states.active[]`
- **Estado final**: `states.closed[0]`
- **Uso por contexto**:
  - **Sprint completo**: todos los estados activos + cerrado
  - **Trabajo activo**: solo `states.active`
  - **Finalizados**: solo `states.closed`

> **Regla fundamental**: SIEMPRE consultar work items de la iteración actual (sprint activo), nunca del historial completo, salvo especificación contraria.

## 2. Estructura y jerarquía de work items

### Jerarquía
Leer `active-workflow.json > hierarchy` para el orden exacto (ej. `["feature", "task", "subtask"]`).
Los nombres reales de los tipos se leen de `active-workflow.json > workItemTypes`.

### Definición y Ciclo de Vida
- **Nivel superior (Feature/Epic)**: Entregable de valor completo que puede durar varios sprints. El esfuerzo del nivel superior NO puede ser menor a la suma de sus hijos. Alcance controlado y verificable por el equipo.
- **Nivel medio (Tarea/Historia)**: Debe ejecutarse y completarse dentro de un único sprint.
- **Nivel inferior (Subtarea/Task)**: Unidad atómica. Se asume que toma 1 día o menos.

### Reglas de herencia y propagación
- **Herencia automática**: Tags, AreaPath, IterationPath se heredan del padre
- **Propagación de estados**: Cuando el nivel inferior cambia de estado inicial → activo/cerrado, el padre cambia a activo
- **Composición obligatoria**: Toda Tarea DEBE tener ≥ 1 elemento hijo con objetivos específicos

### Campos obligatorios por tipo
Los campos obligatorios para cada tipo se leen de `active-workflow.json > fields.<Tipo>.required`.
Los valores permitidos para campos Custom se leen de `active-workflow.json > fields.<Tipo>.custom.<campo>.allowedValues`.

> **NUNCA crear un work item con campos faltantes o placeholders vacíos.** Si un campo es requerido y no se tiene el valor, preguntar antes de crear.

## 3. Sistema de evidencias

### Reglas fundamentales
- **Obligatoriedad según rol**: Ver `active-profile.json > userRole`
  - `developer` o `both`: Toda Subtarea DEBE tener evidencia del trabajo realizado
  - `creator`: Se recomienda, no es bloqueante para cerrar
- **Archivo local**: SIEMPRE crear archivo `.md` con evidencia real (NUNCA vacío)
- **Nomenclatura**: `subtarea_<workItemId>_<titulo_con_guiones_bajos>_evidencia.md`
- **Ubicación**: Dentro de `tasks/<workItemId> - <título>/`
- **Creación**: PREGUNTAR al usuario antes de crear archivos de evidencia

### Opciones de adjunto en Azure DevOps
1. **Preferido - Subida manual**: Usuario adjunta directamente en ADO
2. **Alternativo - Script**: `scripts/attach-evidence.sh <workItemId> <archivo>` (automatización)
3. **Como comentario**: Copiar contenido del `.md` como comentario HTML

### Proceso con script automatizado
```bash
./scripts/attach-evidence.sh <workItemId> <archivo_evidencia>
```
El script genera el comando MCP con los valores del perfil activo:
```
mcp_spring-mcp-se_azuredevops_wit_attachments
  operation: "add_to_work_item"
  project: "<active-profile.json > ado.project>"
  workItemId: <workItemId>
  dataUrl: "<data:application/zip;base64,...>"
  fileName: "<filename.zip>"
  contentType: "application/zip"
  comment: "Evidencia del trabajo completado"
```

## 4. Estructura de archivos y sincronización

### Convención de carpetas por Tarea
El patrón de carpeta se lee de `active-workflow.json > folderPattern` (ej. `tasks/{id} - {title}/`).

```
tasks/<workItemId> - <título>/
├── README.md                                    # Resumen, criterios, entregables
├── task.json                                    # Metadatos y sincronización
├── subtasks.json                                # Array subtareas con campos ADO
├── subtarea_<workItemId>_<titulo>_evidencia.md  # Evidencias obligatorias
└── [otros archivos]                             # Entregables específicos
```

### Convención para Tareas Externas (Solo elementos asignados)
Cuando el usuario tiene asignados elementos hijo pero el padre pertenece a otro usuario:
1. **Nomenclatura carpeta**: `tasks/<parentId> - [EXTERNA] <título_padre>/`
2. **Propiedades task.json**:
   - `assignedTo`: "Externo"
   - `isExternal`: true
   - `note`: "Tarea externa. Solo gestiono subtareas asignadas."
3. **README.md**: Advertencia explícita de que la tarea pertenece a otro responsable.

### Esquemas JSON
- **task.json**: `workItemId`, `title`, `state`, `assignedTo`, `scheduledDate`, `week`, `syncStatus`, info de evidencia
- **subtasks.json**: Array con `title`, `description`, `state`, `evidenciaFile`, `adoFields`, campos del workflow activo

### Proceso de sincronización con Azure DevOps

#### Preparación
1. Completar mapeo de campos ADO en cada elemento hijo (según `active-workflow.json`)
2. Marcar `syncStatus: "pending"`
3. Establecer `adoSync.ready: true` cuando no falten campos
4. Actualizar conteos de subtareas

#### Ejecución
1. Crear elementos en ADO con campos mapeados → guardar `createdId`
2. **Sincronizar estados**: Mantener campo `state` en JSON locales = estado real ADO
3. **Aplicar propagación**: Actualizar padre cuando hijo cambie de estado inicial
4. **Adjuntar evidencias**: Priorizar subida manual, verificar `evidenciaAdjuntada: true`
5. **Finalizar**: Cambiar `syncStatus: "done"`, actualizar `task.json`, anotar en README.md

## 5. Reglas de cierre

### Restricciones obligatorias
1. **NO modificar** título ni descripción al cerrar
2. **Agregar comentario** explicando el cierre
3. **Mantener remaining work original** (no poner en cero)
4. **Verificar asignación**: Solo cerrar work items asignados al usuario del perfil activo
5. **Dependencias**: Solo cerrar una Tarea cuando TODOS sus hijos estén cerrados

### Validaciones antes del cierre
- [ ] Archivo `.md` de evidencia existe y tiene contenido real (si `userRole` es `developer` o `both`)
- [ ] Work item asignado al usuario en `active-profile.json > user.email`
- [ ] Para nivel medio: todos los hijos están cerrados en ADO
- [ ] Estado sincronizado entre JSON locales y Azure DevOps

## 6. Consultas WIQL

### Configuración base
Los valores de proyecto y equipo se leen de `active-profile.json`. El contexto API siempre usa:
```json
{
  "project": "<active-profile.json > ado.project>",
  "team": "<active-profile.json > ado.team>",
  "wiql": "[query]"
}
```

### 🚨 REGLA CRÍTICA: Campos de Contenido Extenso
> **❌ NUNCA incluir en queries WIQL masivos**: `[System.Description]`, `[Microsoft.VSTS.Common.AcceptanceCriteria]`, `[System.History]`
>
> **✅ CONSULTAR INDIVIDUALMENTE**: Usar `mcp_spring-mcp-se_azuredevops_wit_work_items` con `operation="get"` y `raw=true`
>
> **Razón**: Estos campos contienen información extensa que satura el contexto y degrada el rendimiento.

### Templates base (campos estándar)
Siempre incluir: `[System.Id], [System.WorkItemType], [System.Title], [System.State], [System.AssignedTo], [System.CreatedBy], [System.Tags]`
Agregar campos Custom relevantes definidos en `active-workflow.json`.

#### Work items del Sprint actual (rol: developer o both)
```sql
SELECT [System.Id], [System.WorkItemType], [System.Title], [System.State],
       [System.AssignedTo], [System.Tags], [Microsoft.VSTS.Scheduling.RemainingWork]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.AssignedTo] = @Me
  AND [System.State] IN ('<states.active[0]>', '<states.active[1]>', ...)
  AND [System.IterationPath] = @CurrentIteration
ORDER BY [System.WorkItemType] DESC, [Microsoft.VSTS.Scheduling.StartDate] ASC
```

#### Work items del Sprint actual (rol: creator — todo el equipo)
```sql
SELECT [System.Id], [System.WorkItemType], [System.Title], [System.State],
       [System.AssignedTo], [System.Tags]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.State] IN ('<states.active[0]>', '<states.active[1]>', ...)
  AND [System.IterationPath] = @CurrentIteration
ORDER BY [System.AssignedTo] ASC, [System.WorkItemType] DESC
```

#### Todos los estados (sincronización completa)
```sql
SELECT [System.Id], [System.WorkItemType], [System.Title], [System.State],
       [System.AssignedTo], [System.Tags]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.AssignedTo] = @Me
  AND [System.State] IN ('<todos los estados>')
ORDER BY [System.WorkItemType] DESC, [Microsoft.VSTS.Scheduling.StartDate] ASC
```

> **Regla de presentación**: Cada ejecución de query WIQL DEBE mostrar inmediatamente una tabla con TODOS los campos recuperados ANTES de continuar con cualquier otra acción.

## 7. Buenas prácticas operativas

### Planificación
- Balancear horas diarias para no exceder la capacidad total del sprint
- Crear elementos hijo específicos con entregables diferenciados (evitar genéricos)
- Consultar archivo `restricciones_sprint` (si existe) para restricciones del sprint activo

### Documentación y compatibilidad
- **Work items**: Descripción clara + criterios de aceptación en campo específico (NO en descripción)
- **Diagramas**: Solo ASCII en Azure DevOps (Mermaid NO compatible con work items)
- **Caracteres**: Evitar tildes técnicas, usar emojis básicos `✅ ❌ 🔴 🟢 ⚠️`
- **Placeholders PROHIBIDOS**: NO usar "TBD", "TODO", "Pendiente" o campos vacíos. Completar antes de crear.

### Concisión y Realismo
- Ni descripciones telegráficas ni tratados enciclopédicos
- Lenguaje técnico pero directo, con listas para legibilidad
- Alcance realista dentro del sprint — "Better done than perfect but impossible"
- Siempre explicar términos técnicos en inglés con descripción en español junto al término

### Trazabilidad y sincronización
- Mantener coherencia archivos locales ↔ Azure DevOps
- Consultar estado actual antes de cambios/cierres
- Comentarios obligatorios al cerrar con justificación
- Documentar progreso en README.md de carpeta

## 8. Validaciones y checklists

### Política de campos obligatorios (ESTRICTA)
> Todos los campos requeridos (`active-workflow.json > fields.<Tipo>.required`) DEBEN completarse antes de crear cualquier work item. Sin excepciones ni placeholders.

#### Validación genérica antes de crear (cualquier tipo)
- [ ] Título descriptivo y específico (NO genérico)
- [ ] Estado inicial válido (primero de `states.active`)
- [ ] IterationPath del sprint actual asignado
- [ ] AreaPath correcto del equipo
- [ ] Descripción completa con: contexto, objetivos, riesgos identificados, ruta crítica
- [ ] Criterios de aceptación específicos y medibles (mínimo 3)
- [ ] AssignedTo: Persona específica (NO vacío)
- [ ] Fecha de inicio planificada
- [ ] Todos los campos Custom indicados en `active-workflow.json` con valores válidos de `allowedValues`
- [ ] Tags según convención del equipo (`active-workflow.json > tags`)

#### Validación adicional para nivel inferior (Subtarea/Task)
- [ ] RemainingWork realista (no 0, no valores irreales)
- [ ] Actividad del catálogo (`active-workflow.json > activities`)
- [ ] Campos de estimación si aplica

### Durante el Sprint
- [ ] Estados JSON locales sincronizados con ADO
- [ ] Propagación de estados aplicada (hijo cambia → padre a activo)
- [ ] Evidencias creadas solo tras confirmación del usuario
- [ ] Archivos `.md` con contenido real antes de cerrar
- [ ] Progreso documentado en README.md

### Validación OBLIGATORIA de Comentarios
- [ ] **FORMATO HTML EXCLUSIVAMENTE** — No usar sintaxis Markdown
- [ ] NO usar: `##`, `**`, `-`, `###` u otra sintaxis Markdown
- [ ] Mantener comentarios concisos (<2000 caracteres recomendado)

### Revisión para cierre
- [ ] Carpetas `tasks/` con progreso real
- [ ] Archivos `*_evidencia.md` con contenido real (si aplica por rol)
- [ ] `syncStatus` actualizado en task.json/subtasks.json
- [ ] Fechas programadas vs reales analizadas

## 9. Plantillas de comentarios (FORMATO HTML OBLIGATORIO)

> **🚨 REGLA CRÍTICA**: Todos los comentarios en Azure DevOps DEBEN usar HTML enriquecido.
> **❌ PROHIBIDO**: Sintaxis Markdown (`##`, `**`, `-`, etc.) — se escapa automáticamente.
> **✅ OBLIGATORIO**: Tags HTML (`<h2>`, `<strong>`, `<ul>`, etc.)
> **⚠️ LÍMITE**: Mantener concisos (<2000 caracteres). Comentarios largos pueden causar errores.

### Plantilla de Progreso (SOLO HTML)
```html
<h2>📈 Progreso - [Fecha]</h2>
<h3>✅ Completado</h3>
<ul>
<li>[Tarea específica completada]</li>
</ul>
<h3>🔄 En progreso</h3>
<ul>
<li><strong>[Tarea]</strong>: X% completado, X horas restantes</li>
</ul>
<h3>🚧 Impedimentos</h3>
<ul>
<li><strong>[Impedimento]</strong>: Plan de resolución</li>
</ul>
<h3>📊 Métricas</h3>
<ul>
<li><strong>Tiempo</strong>: X de Y horas estimadas</li>
</ul>
```

### Plantilla de Cierre (SOLO HTML)
```html
<h2>🎉 Work Item Completado - [Fecha]</h2>
<h3>✅ Entregables</h3>
<ul>
<li><strong>[Entregable 1]</strong>: Ubicación/estado</li>
<li><strong>[Entregable 2]</strong>: Validaciones</li>
</ul>
<h3>📄 Evidencias</h3>
<ul>
<li><strong>Documentación</strong>: [Adjunto/Enlace]</li>
</ul>
<h3>📊 Métricas</h3>
<ul>
<li><strong>Esfuerzo</strong>: X horas vs Y estimadas</li>
</ul>
```

### Plantilla de Cierre Administrativo (SOLO HTML)
```html
<h2>🔄 Work Item Cerrado por [Razón] - [Fecha]</h2>
<h3>❌ <strong>Razón del Cierre</strong></h3>
<p>[Explicación detallada del motivo]</p>
<h3>🔍 <strong>Análisis</strong></h3>
<ul>
<li><strong>Problema identificado</strong>: [Descripción]</li>
<li><strong>Acción tomada</strong>: [Solución aplicada]</li>
</ul>
```

### Tags HTML Permitidos en Azure DevOps
- **Estructura**: `<h1>` a `<h3>`, `<p>`, `<br>`, `<hr>`
- **Formato**: `<strong>`, `<em>`, `<u>`, `<s>`
- **Listas**: `<ul>`, `<ol>`, `<li>`
- **Tablas**: `<table>`, `<tr>`, `<td>`, `<th>`
- **Otros**: `<blockquote>`, `<pre>`, `<code>`
- **Estilos inline**: `style="color: #color; background-color: #color"`

### ❌ Errores Comunes a Evitar
```
❌ ## Título (Markdown)          ✅ <h2>Título</h2> (HTML)
❌ **Negrita** (Markdown)        ✅ <strong>Negrita</strong> (HTML)
❌ - Lista item (Markdown)       ✅ <li>Lista item</li> (HTML)
```

## 10. Tags de Identificación y Clasificación

### 10.1 Tags de equipo
Los tags del equipo se leen de `active-workflow.json > tags.team[]`.
Todo Work Item DEBE incluir al menos un tag del equipo.

### 10.2 Tags temporales (Trimestre)
El formato de tag temporal se lee de `active-workflow.json > tags.quarterFormat`.
Ejemplos: `T1-2026`, `Q1-2026` (según el formato configurado).

> El tag de trimestre debe identificarse explícitamente — NO se asume por la fecha del calendario.

## 11. Tags de cierre (estados finales)

Los tags de cierre son opcionales y específicos de cada equipo. Configúralos en:
`active-workflow.json > tags.closure[]` si tu equipo los usa.

Sirven para categorizar work items en estados finales según la causa de cierre:
- Impedimento por capacidad interna
- Impedimento por dependencias externas
- Renuncia planificada a la actividad
- Socialización o validación interna

