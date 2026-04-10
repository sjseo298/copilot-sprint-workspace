# Contexto del Equipo — Ejemplo (Arquitectura)

> Este archivo lo genera el `@setup-wizard` a partir de lo que observa en tu proyecto ADO y lo que tú le describes.
> Edítalo libremente. Los agentes lo leen antes de cada operación para entender cómo trabaja tu equipo.

## Rol del equipo

Este perfil de ejemplo corresponde a un equipo de arquitectura de software que:
- Define estándares técnicos y patrones de diseño para los equipos de desarrollo
- Evalúa y aprueba decisiones arquitectónicas de alto impacto
- Acompaña a los equipos en la adopción de nuevas tecnologías

## Metodología

El equipo usa un framework de sprints de ~11 días hábiles.
La jerarquía de trabajo es: **Feature → Tarea → Subtarea**.
El usuario tiene rol `both`: crea las historias y también las ejecuta.

Las Features representan iniciativas o entregables completos de un quarter.
Las Tareas descomponen la Feature en unidades ejecutables (típicamente 1–3 días).
Las Subtareas son unidades atómicas de trabajo (típicamente 2–8 horas).

## Convenciones de nomenclatura

- **Tags opcionales**: nombre del equipo + trimestre en formato `T{Q}-{YEAR}` (ej. `T2-2026`)
- **Títulos de Feature**: descriptivos, sin prefijos forzados
- **Títulos de Tarea/Subtarea**: verbo en infinitivo + objeto (ej. "Configurar proxy Apigee", "Validar autenticación OAuth")

## Criterios de aceptación

Se escriben en HTML con lista `<ul><li>✅ criterio</li></ul>`.
Cada criterio debe ser verificable y objetivo.
No se aceptan criterios vagos como "funciona correctamente" sin métricas.

## Evidencias

Toda Subtarea cerrada requiere evidencia adjuntada al work item en ADO.
La evidencia se genera como archivo `*_evidencia.md` en la carpeta local de la tarea.
El script `attach-evidence.sh` convierte el archivo a base64 y lo adjunta via MCP.

## Priorización

- **Prioridad 1**: Bloqueantes o compromisos de sprint inamovibles
- **Prioridad 2**: Valor alto, ejecutar cuando no hay prioridad 1 pendiente

## Impedimentos

Cuando una Tarea está en estado "Impedimento", se documenta en la descripción el bloqueante específico y el equipo responsable de desbloquearlo. No se cierra la tarea hasta resolver el impedimento.
