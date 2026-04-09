# Catálogo de Campos — Architecture Team (Example)

> Generado automáticamente por `@setup-wizard`. Actualizar ejecutando el wizard nuevamente.

## Feature

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.Description` | Descripción | HTML | ✅ | Libre |
| `Microsoft.VSTS.Common.AcceptanceCriteria` | Criterios de Aceptación | HTML | ✅ | Libre |
| `System.AreaPath` | Área | Ruta | ✅ | Definido por proyecto ADO |
| `System.IterationPath` | Iteración | Ruta | ✅ | Definido por proyecto ADO |
| `System.Tags` | Etiquetas | Texto | ✅ | Libre (por convención: `[ARQ] Automatización; T1-2026`) |
| `Microsoft.VSTS.Scheduling.Effort` | Esfuerzo | Decimal | ✅ | Número positivo |

## Tarea

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.Description` | Descripción | HTML | ✅ | Libre |
| `Microsoft.VSTS.Common.AcceptanceCriteria` | Criterios de Aceptación | HTML | ✅ | Libre |
| `System.AssignedTo` | Asignado a | Usuario | ✅ | Miembro del equipo |
| `System.AreaPath` | Área | Ruta | ✅ | Definido por proyecto ADO |
| `System.IterationPath` | Iteración | Ruta | ✅ | Definido por proyecto ADO |
| `System.Tags` | Etiquetas | Texto | ✅ | Libre |
| `Custom.Prioridad` | Prioridad | Número (lista cerrada) | ✅ | `1`, `2` |

## Subtarea

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.Description` | Descripción | HTML | ✅ | Libre |
| `System.AssignedTo` | Asignado a | Usuario | ✅ | Miembro del equipo |
| `System.AreaPath` | Área | Ruta | ✅ | Definido por proyecto ADO |
| `System.IterationPath` | Iteración | Ruta | ✅ | Definido por proyecto ADO |
| `System.Tags` | Etiquetas | Texto | ✅ | Libre |
| `Custom.Prioridad` | Prioridad | Número (lista cerrada) | ✅ | `1`, `2` |
| `Microsoft.VSTS.Scheduling.RemainingWork` | Horas Restantes | Decimal | ✅ | Número positivo |
| `Microsoft.VSTS.Common.Activity` | Actividad | Texto (lista cerrada) | ✅ | `Development`, `Analysis`, `Design`, `Testing`, `Documentation` |
| `Custom.EstimacionInicial` | Estimación Inicial | Número (lista cerrada) | ✅ | `1`, `2`, `3`, `5`, `8` |
| `Custom.TipoDeSubtarea` | Tipo de subtarea | Texto (lista cerrada) | ❌ | `Subtarea`, `Bug` |

---

> **Nota sobre GUIDs de campos Custom:** Azure DevOps a veces expone campos Custom con GUIDs en la referencia técnica (ej. `Custom.c12a8be8-c31b-42ad-b201-0b64e1f59cea`). El wizard resuelve estos GUIDs al nombre legible y guarda la referencia estable en `workflow.json`. Si ves un GUID aquí, ejecuta el wizard nuevamente para resolverlo.
