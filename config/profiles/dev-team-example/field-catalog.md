# Catálogo de Campos — Equipo Desarrollo (Ejemplo)

> Generado automáticamente por `@setup-wizard`. Actualizar ejecutando el wizard nuevamente.

## Epic

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.Description` | Descripción | HTML | ✅ | Libre |

## User Story

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.Description` | Descripción | HTML | ✅ | Libre |
| `Microsoft.VSTS.Common.AcceptanceCriteria` | Criterios de Aceptación | HTML | ✅ | Libre |
| `System.AssignedTo` | Asignado a | Usuario | ✅ | Miembro del equipo |
| `Microsoft.VSTS.Scheduling.StoryPoints` | Story Points | Decimal | ✅ | Número positivo |

## Task

| Campo (referencia técnica) | Nombre en UI | Tipo | Requerido | Valores permitidos |
|---|---|---|---|---|
| `System.Title` | Título | Texto | ✅ | Libre |
| `System.AssignedTo` | Asignado a | Usuario | ✅ | Miembro del equipo |
| `Microsoft.VSTS.Scheduling.RemainingWork` | Horas Restantes | Decimal | ✅ | Número positivo |
| `Microsoft.VSTS.Common.Activity` | Actividad | Texto (lista cerrada) | ✅ | `Development`, `Testing`, `Design`, `Documentation` |
