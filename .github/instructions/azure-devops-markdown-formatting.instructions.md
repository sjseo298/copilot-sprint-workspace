---
applyTo: '**'
---

Para los campos de Descripcion y de Criterios de Aceptacion en los work items de Azure DevOps, se debe seguir el siguiente formato html.

# Instrucciones de Formato Markdown para Azure DevOps

## Contexto y Aplicación

Este documento establece las reglas de formato Markdown para **todos los textos** que se envían a Azure DevOps, basado en la documentación oficial de Microsoft. Aplica específicamente a:

- **Descripciones de work items** (Tareas, Subtareas, Features)
- **Criterios de aceptación** (campo específico)
- **Comentarios** en work items y pull requests
- **Notas** y actualizaciones de progreso
- **Documentación** en wikis del proyecto
- **Pull requests** y revisiones de código
- **README files** en repositorios Git
- **Markdown widgets** en dashboards

**Referencia oficial**: [Use Markdown in Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/project/wiki/markdown-guidance?view=azure-devops)

## Compatibilidad por Feature en Azure DevOps

Azure DevOps soporta diferentes elementos Markdown según el contexto. La siguiente tabla muestra la compatibilidad:

| Elemento | Definition of Done | Markdown Widget | Pull Requests | README Files | Wiki Files |
|----------|:------------------:|:---------------:|:-------------:|:------------:|:----------:|
| Headers | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Párrafos y saltos de línea | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Block quotes | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Líneas horizontales | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Énfasis (negrita, cursiva) | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Code highlighting | ❌ | ❌ | ✔️ | ✔️ | ✔️ |
| Suggest change | ❌ | ❌ | ✔️ | ❌ | ❌ |
| Tablas | ❌ | ✔️ | ✔️ | ✔️ | ✔️ |
| Listas | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Links | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Imágenes | ❌ | ✔️ | ✔️ | ✔️ | ✔️ |
| Checklist o task list | ❌ | ❌ | ✔️ | ❌ | ✔️ |
| Emojis | ❌ | ❌ | ✔️ | ❌ | ✔️ |
| Escape caracteres especiales | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ |
| Attachments | ❌ | ❌ | ✔️ | ❌ | ✔️ |
| Notación matemática | ❌ | ❌ | ✔️ | ❌ | ✔️ |
| Diagramas Mermaid | ❌ | ❌ | ❌ | ❌ | ✔️ |

**Limitaciones importantes:**
- Azure DevOps **NO soporta JavaScript o iframes**
- **Internet Explorer NO soporta diagramas Mermaid**
- Links a archivos compartidos (`file://...`) **NO están soportados** por seguridad

## 1. Headers (Encabezados)

Azure DevOps soporta 6 niveles de headers usando la sintaxis `#`:

```markdown
# Header Principal (H1)
## Sección Principal (H2)
### Subsección (H3)
#### Detalle (H4)
##### Nota menor (H5)
###### Detalle mínimo (H6)
```

### Reglas oficiales:
- **SIEMPRE usar espacio después del #**: `## Título` ✅, `##Título` ❌
- **Headers crean anclas automáticas** para navegación interna
- **Conversión a ID automática**: Espacios → guiones, mayúsculas → minúsculas, caracteres especiales se ignoran

## 2. Párrafos y Saltos de Línea

**Azure DevOps maneja saltos de línea de manera diferente según el contexto:**

### En Pull Requests y Comentarios:
- **Enter una vez**: Crea salto de línea simple
- **Enter dos veces**: Crea párrafo nuevo con línea en blanco

### En Archivos Markdown y Widgets:
- **Dos espacios + Enter**: Salto de línea dentro del mismo párrafo
- **Enter dos veces**: Párrafo nuevo separado

## 3. Block Quotes (Citas)

Para destacar información importante, citas o referencias:

```markdown
> **Nota importante**: Esta información proviene de la official architecture documentation.

> Para implementar correctamente el patrón Clean Architecture,
> es necesario separar claramente las capas de dominio, aplicación e infraestructura.

>> **Nested quote**: Para citas dentro de citas use doble bracket.

>>> **Triple nested**: Para casos excepcionales que requieren múltiples niveles.
```

## 4. Líneas Horizontales

Para separar secciones visualmente:

```markdown
Contenido de la primera sección

---

Contenido de la segunda sección separada

---

Contenido final después de la segunda separación
```

### ✅ Aplicación en work items:
```markdown
## Análisis de Requerimientos
Detalle del análisis realizado sobre los requerimientos técnicos.

---

## Decisiones de Diseño
Listado de decisiones arquitectónicas tomadas durante el Sprint.

---

## Próximos Pasos
Acciones planificadas para el siguiente Sprint.
```

## 5. Énfasis de Texto

Azure DevOps soporta múltiples estilos de énfasis:

| Estilo | Resultado | Sintaxis |
|--------|-----------|----------|
| Cursiva | *texto en cursiva* | `*texto*` o `_texto_` |
| Negrita | **texto en negrita** | `**texto**` o `__texto__` |
| Tachado | ~~texto tachado~~ | `~~texto~~` |
| Combinado | ***negrita y cursiva*** | `***texto***` |
| Combinado | ~~**tachado y negrita**~~ | `~~**texto**~~` |

**Nota:** Azure DevOps no soporta subrayado con sintaxis Markdown. En wikis se puede usar `<u>texto</u>`.

## 6. Code Highlighting

### 6.1 Código en Bloque (disponible en PRs, README, Wiki)

```javascript
// Ejemplo de código JavaScript
const evaluateRepository = async (repoUrl) => {
  const analysis = await analyzer.scan(repoUrl);
  return analysis.compliance.score;
};
```

### 6.2 Código Inline

Para código dentro del texto: `variable`, `método()`, `@Component`

### 6.3 Identificadores de Lenguaje Soportados

Los más comunes:
- `javascript` o `js`
- `java`
- `python`
- `csharp` o `c#`
- `sql`
- `yaml` o `yml`
- `json`
- `xml`
- `markdown` o `md`
- `bash` o `shell`
- `powershell`

## 7. Suggest Changes (Solo Pull Requests)

Para sugerir cambios específicos en Pull Requests:

```suggestion
// Cambio sugerido en el código
for i in range(A, B+100, C):
    process(i)
```

**Nota:** Esta funcionalidad solo está disponible en comentarios de Pull Requests.

## 8. Tablas

### 8.1 Sintaxis Básica

```markdown
| Columna 1 | Columna 2 | Columna 3 |
|-----------|-----------|-----------|
| Valor 1   | Valor 2   | Valor 3   |
| Fila 2    | Dato 2    | Info 3    |
```

### 8.2 Alineación de Columnas

```markdown
| Izquierda | Centrado | Derecha |
|:----------|:--------:|--------:|
| Texto     | Texto    | Texto   |
| Align left| Center   | Right   |
```

### 8.3 Reglas Oficiales para Tablas
- **Cada fila en línea separada** terminada con CR o LF
- **Columnas con guiones `-` y pipe `|`**: `|---|---|---|`
- **Headers en primera fila**: `| First | Middle | Last |`
- **Alineación con dos puntos**: `|:--|:--:|--:|` (izq, centro, der)
- **Escapar pipe con backslash**: `| Describe el símbolo \| en tabla |`
- **Saltos de línea con HTML**: `<br/>` (solo en wikis)
- **Espacios alrededor de work items**: ` #123 ` en contenido de tabla

## 9. Listas

### 9.1 Listas Ordenadas

```markdown
1. Primer paso del procedimiento
1. Segundo paso (usar 1. para auto-numeración)
1. Tercer paso final

<!-- También válido con numeración manual -->
1. Primer paso
2. Segundo paso  
3. Tercer paso
```

### 9.2 Listas No Ordenadas

```markdown
- Primer elemento de la lista
- Siguiente elemento
- Último elemento

<!-- También válido con asterisco -->
* Primer elemento
* Siguiente elemento
* Último elemento
```

### 9.3 Listas Anidadas

```markdown
1. Primer paso principal
   - Subtarea A
   - Subtarea B
     - Detalle específico
     - Otro detalle
   - Subtarea C
2. Segundo paso principal
   1. Primer sub-paso
   1. Segundo sub-paso
3. Tercer paso final
   - Verificación final
   - Documentación
```

### 9.4 Reglas Oficiales para Listas
- **Cada item en línea separada**
- **Listas ordenadas**: Número + punto (`1. Item`)
- **Listas no ordenadas**: Guión `-` o asterisco `*`
- **Espaciado**: Línea en blanco antes y después de la lista inicial
- **Anidamiento**: Indentación correcta, sin líneas extras antes/después

## 10. Enlaces y Referencias

### 10.1 Sintaxis Estándar
`[Texto del enlace](URL o ruta)`

### 10.2 Enlaces a Work Items
- **Automático**: `#123` (crea enlace automático al work item 123)
- **Evitar conflictos**: `\#FF0000` (para colores hex que no son work items)

### 10.3 URLs Automáticas
En Pull Requests y Wikis, las URLs que inician con HTTP/HTTPS se convierten automáticamente en enlaces.

### 10.4 Enlaces Relativos Soportados

#### En README files (repositorio):
```markdown
[Archivo en el repo](./src/main/java/Validator.java)
[Documentación](/docs/architecture-guide.md)
[Archivo TFVC]($/project/folder/readme.md)
```

#### En Wiki pages:
```markdown
[Página hijo](/parent-page/child-page)
[Otra sección de wiki](/architecture/patterns)
```

#### En Markdown widgets:
```markdown
[URL externa](http://address.com)
```

### 10.5 Anchor Links (Enlaces a Secciones)

Los headers crean automáticamente anclas para navegación:

```markdown
#### Arquitectura del Sistema

Para más detalles sobre arquitectura, ver [sección superior](#arquitectura-del-sistema).

[Enlace a otra página con sección](./other-page.md#configuracion-inicial)
```

## 11. Imágenes y Archivos

### 11.1 Sintaxis de Imágenes
`![Texto alternativo](ruta/url de la imagen)`

### 11.2 Rutas Soportadas
```markdown
<!-- Ruta relativa -->
![Diagrama arquitectura](./images/architecture-diagram.png)

<!-- Ruta absoluta en Git -->
![Logo](media/team-logo.png)

<!-- Ruta absoluta en TFVC -->  
![Esquema]($/project/docs/images/schema.png)

<!-- URL externa -->
![Banner](https://company.com/images/banner.jpg)
```

### 11.3 Control de Tamaño
```markdown
<!-- Especificar ancho y alto -->
![Diagrama](./diagram.png =500x250)

<!-- Solo ancho -->
![Gráfico](./chart.png =300x)
```

### 11.4 Adjuntar Archivos

**Métodos soportados en Pull Requests y Wikis:**
1. **Drag & Drop**: Arrastrar archivo al área de comentario/edición
2. **Paste**: Pegar imagen del clipboard directamente  
3. **Attach Icon**: Usar el ícono de clip 📎 en la toolbar

**Formatos soportados:**
- **Imágenes**: PNG, GIF, JPEG, ICO
- **Documentos**: MD, MSG, MPP, DOC/DOCX, XLS/XLSX, CSV, PPT/PPTX, TXT, PDF
- **Código**: CS, XML, JSON, HTML, HTM, LYR, PS1, RAR, RDP, SQL
- **Comprimidos**: ZIP, GZ
- **Video**: MOV, MP4
- **Visio**: VSD, VSDX

## 12. Checklists y Task Lists

**Disponible en Pull Requests y Wiki Files únicamente.**

### 12.1 Sintaxis
```markdown
- [x] Tarea completada
- [ ] Tarea pendiente  
- [ ] Otra tarea por hacer
```

### 12.2 Con Numeración
```markdown
1. [x] Primera tarea completada
1. [ ] Segunda tarea pendiente
1. [ ] Tercera tarea por hacer
```

### 12.3 Reglas Oficiales
- **Espacios exactos**: `- [ ]` con espacio entre corchetes para tareas nuevas
- **Completado**: `[x]` con x para tareas terminadas
- **Precedido por guión y espacio**: `- ` o número + espacio
- **NO usar dentro de tablas**
- **Interactivo**: Los usuarios pueden marcar/desmarcar en la vista publicada

## 13. Emojis

**Disponible en Pull Requests y Wiki Files únicamente.**

### 13.1 Sintaxis
`:nombre_emoji:`

### 13.2 Emojis Comunes Soportados
```markdown
Estado del trabajo:
- :white_check_mark: o :heavy_check_mark: ✅ (completado)
- :x: ❌ (error/problema)  
- :warning: ⚠️ (advertencia)
- :construction: 🚧 (en progreso)

Reacciones:
- :+1: 👍 (me gusta)
- :-1: 👎 (no me gusta)
- :smile: 😄 (contento)
- :cry: 😢 (triste)
- :heart: ❤️ (amor)

Técnicos:
- :bug: 🐛 (bug)
- :rocket: 🚀 (deployment/lanzamiento)
- :gear: ⚙️ (configuración)
- :books: 📚 (documentación)
```

### 13.3 Escapar Sintaxis de Emoji
```markdown
Para mostrar sintaxis literal: \:smile\: en lugar del emoji 😄
```

## 14. Caracteres Especiales como Texto Literal

Para mostrar caracteres especiales sin que se interpreten como Markdown:

### 14.1 Caracteres que Requieren Escape
- Backslash: `\\`
- Backticks: `\``
- Asteriscos: `\*`
- Guiones bajos: `\_`
- Llaves: `\{` `\}`
- Corchetes: `\[` `\]`
- Paréntesis: `\(` `\)`
- Hash: `\#`
- Puntos: `\.`
- Signos de exclamación: `\!`

### 14.2 Ejemplo de Uso
```markdown
Para mostrar \*\*texto\*\* sin que se vuelva **negrita**

Mostrar código literal: \`console.log()\` sin formato de código

Hashtag sin work item: \#frontend en lugar de #frontend

Expresiones: E = mc\^2 sin superíndice

Archivos: config\.json sin formato especial
```

## 15. Diagramas Mermaid en Azure DevOps Wiki

**IMPORTANTE**: Los diagramas Mermaid solo están disponibles en **Wiki Files**. No funcionan en Pull Requests, README files, Markdown widgets, ni otros contextos.

### 15.1 Sintaxis Base para Mermaid

```markdown
::: mermaid
<tipo_de_diagrama>
   <información_del_diagrama>
:::
```

**Nota crítica**: Use tres dos puntos (`:`) para iniciar y cerrar, no comillas invertidas.

### 15.2 Limitaciones Oficiales de Azure DevOps

Azure DevOps proporciona **soporte limitado** para sintaxis Mermaid:

#### ❌ Sintaxis NO Soportada:
- La mayoría de tags HTML
- Font Awesome icons
- Sintaxis `flowchart` (usar `graph` en su lugar)
- LongArrow `---->`
- Enlaces desde/hacia elementos `subgraph`
- Muchas características avanzadas de Mermaid

#### ❌ Limitación de Navegador:
- **Internet Explorer NO soporta Mermaid**
- Los diagramas no se renderizan en IE

### 15.3 Tipos de Diagramas Soportados

Los principales tipos soportados:
- `sequenceDiagram`
- `gantt`
- `graph` (NO `flowchart`)
- `classDiagram`
- `stateDiagram-v2`
- `pie`
- `journey`
- `requirementDiagram`
- `gitGraph`
- `erDiagram`
- `timeline`

**Nota**: Para documentación completa y ejemplos de Mermaid, consultar el archivo de instrucciones específico de diagramas.

## 16. Funcionalidades Avanzadas de Wiki

### 16.1 Tabla de Contenidos

```markdown
[[_TOC_]]
```

**Reglas**:
- **Case-sensitive**: `[[_TOC_]]` funciona, `[[_toc_]]` no
- Solo la **primera instancia** se renderiza
- **Solo headers Markdown** (`#`), no HTML tags
- Se puede colocar **en cualquier parte** del documento

### 16.2 Tabla de Subpáginas

```markdown
[[_TOSP_]]
```

Crea tabla automática de páginas hijas en el wiki.

### 16.3 Secciones Colapsables

```markdown
<details>
  <summary>Detalles de Implementación</summary>

  ## Información Detallada
  Esta sección contiene información técnica específica
  que no necesita estar visible inicialmente.
  
  - Punto técnico 1
  - Punto técnico 2
</details>
```

### 16.4 Videos Embebidos

```markdown
::: video
<iframe width="640" height="360" 
        src="https://www.youtube.com/embed/VIDEO_ID" 
        allowfullscreen style="border:none">
</iframe>
:::
```

### 16.5 Query Results de Azure Boards

```markdown
:::
query-table 6ff7777e-8ca5-4f04-a7f6-9e63737dddf7
:::
```

### 16.6 Menciones @ 

```markdown
@<usuario> o @<grupo>
```

En código directo: `@<{identity-guid}>`

### 16.7 HTML Rich Text

```markdown
<font color="red">Texto en rojo</font>
<center>Texto centrado</center>
<sup>superíndice</sup> y <sub>subíndice</sub>
<small>texto pequeño</small>
<big>texto grande</big>
```

## 17. Validaciones y Buenas Prácticas

### 17.1 ✅ Checklist de Calidad para Markdown

#### Antes de enviar a Azure DevOps:
- [ ] Headers con espacios correctos después de `#`
- [ ] Enlaces válidos y accesibles
- [ ] Imágenes con texto alternativo descriptivo
- [ ] Tablas con alineación correcta
- [ ] Caracteres especiales escapados donde corresponde
- [ ] Sintaxis de código con identificador de lenguaje
- [ ] Listas con indentación apropiada
- [ ] Referencias a work items con formato `#123`

#### Para Diagramas Mermaid (solo wikis):
- [ ] Probado en Mermaid Live Editor
- [ ] Usa sintaxis soportada por Azure DevOps  
- [ ] No incluye características HTML avanzadas
- [ ] Legible en diferentes tamaños de pantalla

### 17.2 ❌ Errores Comunes a Evitar

#### Formateo:
```markdown
❌ ##Sin espacio después del hash
✅ ## Con espacio correcto

❌ Enlaces rotos: [Documento](./docs/inexistente.md)
✅ Enlaces válidos: [Architecture Guide](/wiki/arch-guide)

❌ Tablas sin headers: | Dato1 | Dato2 |
✅ Tablas completas: 
| Header1 | Header2 |
|---------|---------|
| Dato1   | Dato2   |
```

#### Work Items:
```markdown
❌ Descripción sin estructura ni headers
❌ Criterios de aceptación mezclados con descripción
❌ Sin referencias a work items relacionados
❌ Comentarios sin contexto ni evidencias

✅ Estructura clara con headers y secciones
✅ Criterios en campo específico con formato estructurado  
✅ Referencias explícitas: #12345, #12346
✅ Comentarios con evidencias y progreso detallado
```

### 17.3 Optimización para Diferentes Contextos

#### Definition of Done (Boards):
- Usar headers para organizar criterios
- Listas para requerimientos específicos
- Enlaces a documentación relevante
- **No usar**: tablas, imágenes, código

#### Pull Request Comments:
- Syntax highlighting para código sugerido
- Suggest changes cuando sea aplicable
- Checklists para verificaciones
- Emojis para claridad emocional

#### Work Item Comments:
- **Usar HTML enriquecido** en lugar de Markdown para máximo control visual
- **Markdown se escapa** en ADO comments - usar HTML exclusivamente
- **Tags soportados**: `<h1>-<h3>`, `<p>`, `<strong>`, `<em>`, `<table>`, `<ul>`, `<ol>`, `<blockquote>`, `<pre>`, `<hr>`
- **Estilos inline**: `style="color: #color; background-color: #color"` funcionales
- **Emojis abundantes**: Excelente soporte sin limitaciones
- **Tablas avanzadas**: `border`, `cellpadding`, `cellspacing`, zebra striping
- **Limitaciones**: No JavaScript, iframes, CSS externo, formularios

#### README Files:
- Estructura clara con TOC implícito
- Code highlighting para ejemplos
- Imágenes para diagramas de arquitectura
- Enlaces relativos al repositorio

#### Wiki Pages:
- Tabla de contenidos con `[[_TOC_]]`
- Diagramas Mermaid para visualizaciones
- Secciones colapsables para información detallada
- Videos embebidos para demos

#### Markdown Widgets:
- Contenido conciso y visual
- Tablas para métricas y status
- Enlaces a recursos externos
- **No usar**: características avanzadas

### 17.4 Elementos Prohibidos
- ❌ Diagramas sin contenedor de fondo blanco
- ❌ Fondos transparentes o por defecto
- ❌ Texto negro sobre fondos oscuros
- ❌ Colores aleatorios sin semántica
- ❌ Diagramas sin configuración de tema
- ❌ Herramientas diferentes a Mermaid

---

**Actualización**: Septiembre 2025 | **Fuente**: [Azure DevOps Markdown Guidance](https://learn.microsoft.com/en-us/azure/devops/project/wiki/markdown-guidance?view=azure-devops) | **Mantenido por**: Architecture Team
