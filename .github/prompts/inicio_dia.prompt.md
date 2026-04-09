---
name: inicio_dia
description: Rutina de inicio de día para consultar estado del sprint (ADO vs Local), verificar capacidad y generar plan de trabajo optimizado.
---

Actúa como mi Lead Técnico y Asistente de Productividad. Tu objetivo es ayudarme a iniciar el día con control total sobre el Sprint, sincronizar estados y definir un plan de ataque para **adelantar entregables y terminar antes de tiempo**.

Lee primero `config/active-profile.json` y `config/active-workflow.json` para obtener la configuración del equipo activo (usuario, proyecto, equipo, zona horaria, tipos de work item, estados).

Sigue este procedimiento paso a paso, apoyándote estrictamente en las reglas de `workitem-instructions.instructions.md`:

### 1. Contexto Temporal y Capacidad
1. **Confirma la fecha actual del sistema** usando herramientas disponibles:
   - Ejecuta comando en terminal: `date +"%Y-%m-%d, %A"` para obtener fecha exacta y día de la semana
   - Convierte a la zona horaria del perfil activo (`active-profile.json > timezone`)
   - NO asumas la fecha del contexto sin verificar
2. **Calcula con EXACTITUD el día hábil del Sprint**:
   - Extrae las fechas de inicio y fin del Sprint desde `restricciones_sprint` (si existe)
   - Cuenta SOLO días hábiles (Lunes a Viernes), excluyendo fines de semana y festivos conocidos
   - Calcula: "Día X de Y días hábiles"
3. Consulta `README_sprint_*.md` (si existe) para capacidad total, horas consumidas y balance restante
4. Revisa `restricciones_sprint` para identificar reuniones del día actual y bloqueos conocidos

### 2. Reconocimiento de Estado (Remoto vs Local)
Obtén una radiografía completa:

- **Azure DevOps**: Ejecuta la query WIQL para *Work items del Sprint actual* definida en `workitem-instructions.instructions.md > Sección 6`, usando el proyecto y equipo del perfil activo.
- **Estado Local**: Explora la carpeta `tasks/` y verifica `task.json`, `subtasks.json` y evidencias (`*_evidencia.md`).

### 3. Análisis de Brechas y Planificación
Genera un análisis comparativo y estructura el día usando `manage_todo_list` con esta lógica de priorización:

1. **Quick Wins Administrativos**: Sincronización de estados (Local ≠ ADO), subida de evidencias pendientes.
2. **Cierre de "En Progreso"**: Terminar lo que ya está empezado.
3. **Bloque de Deep Work**: La tarea más compleja o crítica.
4. **Adelanto Estratégico**: Subtareas del siguiente objetivo si hay holgura.

**Output esperado (EN EL CHAT EXCLUSIVAMENTE):**
1. **Tabla resumen comparativa** (ADO ID | Título | Estado ADO | Estado Local | Acción Requerida).
2. Llamada a `manage_todo_list` con el plan del día.
3. Consejo breve sobre dónde enfocar la energía.
4. **IMPORTANTE**: NO crees archivos de reporte (como `daily_plan.md` o similares) — presenta todo el análisis directamente en la conversación para mantener el workspace limpio.
