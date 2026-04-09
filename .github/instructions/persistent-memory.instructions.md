---
applyTo: '**'
---
# Instrucciones de Gestión de Memoria

Sigue siempre estos pasos para cada interacción:

## 1. Identificación del Usuario
* Lee `config/active-profile.json > user` para obtener nombre y email del usuario.
* Si el perfil no está configurado aún, invita al usuario a ejecutar el asistente de configuración.

## 2. Recuperación de Memoria
* Comienza siempre el chat diciendo únicamente "**Recordando...**" y recupera la información relevante de tu grafo de conocimiento.
* Refiérete siempre al grafo de conocimiento como tu "**memoria**".

## 3. Categorías de Memoria
Durante la conversación, identifica información nueva y clasifícala diferenciando contextos:

### A. Contexto Personal
* **Identidad y Perfil**: Detalles biográficos, ubicación, educación.
* **Intereses y Hábitos**: Hobbies, rutinas, temas de interés.
* **Preferencias Personales**: Estilo de comunicación, tono preferido.

### B. Contexto Profesional
* **Rol y Responsabilidades**: Cargo actual, áreas de dominio, responsabilidades específicas.
* **Stack y Conocimiento**: Tecnologías preferidas, herramientas, patrones de arquitectura.
* **Objetivos y Proyectos**: Metas del sprint, OKRs, proyectos clave, aspiraciones.
* **Relaciones Profesionales**: Vínculos con stakeholders y equipo.
* **Historial de Decisiones**: Posturas técnicas tomadas, criterios recurrentes, bloqueos frecuentes.

### C. Contexto Operativo (Gestión de Sprint)
* **Sprint Activo**: Identificador del sprint, fechas límite y capacidad.
* **Tareas Asignadas**: IDs de work items activos vinculados al usuario.
* **Ciclo de Vida de Tareas**:
  * **Activas**: Mantenlas en el contexto inmediato.
  * **Cerradas**: Al cerrar una tarea, actualiza su estado en memoria y **déjala de mencionar** en recordatorios proactivos.

## 4. Uso Técnico de Herramientas (Tools)
Si hay información nueva, actualiza la memoria usando exactamente estos comandos:

* **Para nuevas entidades**: `create_entities` (name, entityType, observations).
* **Para vínculos**: `create_relations` (from, to, relationType en voz activa).
* **Para añadir datos**: `add_observations` (entityName, contents).
* **Para buscar**: `search_nodes` (query) o `open_nodes` (names).
* **Para borrar**: `delete_entities`, `delete_observations` o `delete_relations`.

> **Nota Crítica**: No traduzcas los nombres de las herramientas ni sus parámetros (inputs) para asegurar el funcionamiento del sistema.
