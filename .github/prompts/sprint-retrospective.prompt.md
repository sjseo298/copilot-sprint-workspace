---
name: sprint-retrospective
description: Genera un análisis del sprint terminado. Compara planificado vs ejecutado, identifica patrones de bloqueo, y sugiere mejoras para el siguiente sprint.
---

Lee `config/active-profile.json` y `config/active-workflow.json`. Luego lee `restricciones_sprint` y el `README_sprint_*.md` más reciente.

## Objetivo
Generar un análisis estructurado del sprint: qué salió bien, qué falló, cuánto se entregó y qué mejorar.

## Pasos

### 1. Recopilar datos del sprint
Consulta WIQL **todos los estados** (activos y cerrados) del sprint finalizado:

```sql
SELECT [System.Id], [System.WorkItemType], [System.Title], [System.State],
       [System.AssignedTo], [System.Tags],
       [Microsoft.VSTS.Scheduling.RemainingWork],
       [Microsoft.VSTS.Scheduling.OriginalEstimate]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.IterationPath] = @CurrentIteration
ORDER BY [System.WorkItemType] DESC, [System.State] ASC
```

### 2. Analizar métricas
Calcula:
- **Entregados**: count de `states.closed`
- **No entregados**: count de estados activos al finalizar
- **Horas planificadas vs reales** (OriginalEstimate vs RemainingWork final)
- **Features completadas vs incompletas**

### 3. Analizar causas
Agrupa los work items no cerrados por posible causa:
- Estimación incorrecta (tarea tomó más tiempo del esperado)
- Bloqueo externo (dependencia no resuelta)
- Cambio de prioridad (trabajo no planeado surgió)
- Capacidad real vs planeada

Lee `README_sprint_*.md` para impedimentos documentados.

### 4. Revisar estructura local
Verifica en `tasks/`:
- ¿Hay evidencias sin adjuntar?
- ¿Hay subtasks.json con `syncStatus: "pending"`?

### 5. Generar reporte

**Presenta en el chat (NO crear archivo salvo que el usuario lo pida):**

```
## Retrospectiva Sprint <nombre>

### Métricas
| Tipo | Planificadas | Completadas | % |
|------|-------------|-------------|---|
| Features | X | Y | Z% |
| Tareas | X | Y | Z% |
| Subtareas | X | Y | Z% |

Horas: X planificadas → Y reales (Z% desvío)

### ✅ Lo que funcionó bien
- ...

### ⚠️ Oportunidades de mejora
- ...

### 🚧 Bloqueos encontrados
- ...

### 📋 Pendientes para el siguiente sprint
| ID | Título | Causa | Prioridad sugerida |
|----|--------|-------|-------------------|
| ... | ... | ... | ... |

### 💡 Sugerencias para el próximo sprint
- ...
```

### 6. Acción final
Pregunta al usuario:
> "¿Quieres que actualice el README del sprint con este resumen? ¿O prefieres que cree el README del próximo sprint basado en estos pendientes?"
