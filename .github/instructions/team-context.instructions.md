---
applyTo: '**'
---

# Contexto del Equipo

> Este archivo lee su contenido desde el perfil activo. Antes de cualquier operación, lee:
> - `config/active-profile.json` — identidad del usuario, org/proyecto/equipo, zona horaria, rol
> - `config/active-workflow.json` — estados válidos, jerarquía, campos obligatorios por tipo
> - El archivo indicado en `active-profile.json > customContextPath` para contexto narrativo del equipo

## Identidad y configuración base

- **Usuario**: leer `active-profile.json > user.email` y `user.displayName`
- **Organización ADO**: leer `active-profile.json > ado.organization`
- **Proyecto**: leer `active-profile.json > ado.project`
- **Equipo**: leer `active-profile.json > ado.team`
- **Zona horaria**: leer `active-profile.json > timezone`
- **Horas por día**: leer `active-profile.json > workHoursPerDay`
- **Días del sprint**: leer `active-profile.json > sprintDays`
- **Rol del usuario**: leer `active-profile.json > userRole` (`creator` | `developer` | `both`)

## Rol del usuario — impacto en el comportamiento

### `developer`
- Solo trabaja work items asignados al usuario (`AssignedTo = @Me`)
- Las consultas WIQL filtran automáticamente por `@Me`
- `work-item-creator` está limitado a crear el nivel inferior de la jerarquía
- Las evidencias son obligatorias para cerrar work items

### `creator`
- Crea y asigna work items a cualquier miembro del equipo
- Las consultas WIQL muestran el estado de todo el equipo (sin filtro `@Me`)
- `work-item-creator` puede crear cualquier nivel de la jerarquía
- Las evidencias son opcionales (rol de gestión, no de ejecución)

### `both`
- Crea historias Y ejecuta trabajo asignado
- Acceso completo a todos los agentes sin restricciones
- Las consultas WIQL muestran trabajo propio + resumen de equipo disponible
- Las evidencias son obligatorias para los work items que ejecuta

## Reglas generales de comportamiento

- No asumir datos que no estén en `active-profile.json` o `active-workflow.json`
- No hardcodear org, proyecto, equipo ni rutas de área en ninguna operación
- Leer `restricciones_sprint` (sin extensión) en la raíz si existe — contiene restricciones del sprint actual
- La zona horaria es crítica para calcular días hábiles y fechas de sprint
- No se trabaja sábados ni domingos

## Contexto narrativo del equipo

Para entender la metodología, conceptos internos, priorización y reglas de negocio del equipo específico, leer el archivo indicado en:

```
active-profile.json > customContextPath
```

Ese archivo (generado por el `@setup-wizard` y editable libremente) explica cómo piensa el equipo, qué hace, cómo prioriza y qué convenciones usa. Es la fuente de verdad narrativa del contexto.

Si ese archivo no existe o está vacío, operar solo con las instrucciones técnicas genéricas.
