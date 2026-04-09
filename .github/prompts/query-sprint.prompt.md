---
name: query-sprint
description: Consulta rápida del estado del sprint en Azure DevOps. Muestra tabla de work items con estado, horas restantes y brechas de sincronización local.
---

Lee `config/active-profile.json` y `config/active-workflow.json`.

Ejecuta la siguiente consulta WIQL usando el proyecto y equipo del perfil activo. Ajusta los estados (`states.active`) y el tipo de consulta según el `userRole`:

- `developer` o `both` → filtrar por `AssignedTo = @Me`
- `creator` → mostrar todo el equipo (sin filtro AssignedTo)

**NO incluir** los campos `[System.Description]`, `[Microsoft.VSTS.Common.AcceptanceCriteria]` ni `[System.History]` en la query.

```sql
SELECT [System.Id], [System.WorkItemType], [System.Title], [System.State],
       [System.AssignedTo], [System.Tags], [Microsoft.VSTS.Scheduling.RemainingWork],
       [Microsoft.VSTS.Scheduling.StartDate], [System.Parent]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.AssignedTo] = @Me          -- ajustar según rol
  AND [System.State] IN ('...estados activos...')
  AND [System.IterationPath] = @CurrentIteration
ORDER BY [System.WorkItemType] DESC, [Microsoft.VSTS.Scheduling.StartDate] ASC
```

Presenta el resultado como tabla inmediatamente. Luego:

1. Verifica si hay carpetas locales en `tasks/` correspondientes a cada ID.
2. Compara `state` de `task.json` / `subtasks.json` con el estado ADO.
3. Marca con ⚠️ los que tienen discrepancias locales o evidencias sin adjuntar.
4. Calcula total de `RemainingWork` y compara con la capacidad disponible del sprint.

**NO generes archivos de reporte** — presenta todo en el chat.
