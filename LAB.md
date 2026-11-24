# Laboratorio reproducible: lista de tareas local

Este documento define el ejercicio de diseño y sus puntos de control. La preparación del workspace, la verificación de EGM y la clonación de la fuente original están en [README.md](README.md).

## 1. Antes de comenzar

Sigue la sección «Preparación y verificación» de [README.md](README.md) y vuelve aquí cuando termine correctamente.

## 2. Idea fija del laboratorio

**Producto:** herramienta de línea de comandos para gestionar tareas personales en un equipo local.

**Usuario:** una sola persona; no hay cuentas ni red.

**Tecnología:** Python 3, biblioteca estándar y un archivo JSON local. Sin base de datos, servicios, interfaz web ni dependencias de terceros.

**Funciones esperadas:**

1. Crear una tarea con título obligatorio; el sistema le asigna un identificador y estado `pendiente`.
2. Listar tareas, con opción de filtrar por `pendiente` o `completada`.
3. Marcar una tarea existente como `completada`.
4. Conservar las tareas entre ejecuciones en el JSON local.

**Casos que el diseño debe resolver:** título vacío, identificador inexistente, JSON ausente o dañado y escritura interrumpida. Los mensajes al usuario estarán en español. El diseño puede proponer el nombre de los comandos y la ruta del JSON, pero debe dejar esas decisiones explícitas y comprobables.

**Fuera de alcance:** edición, borrado, fechas límite, prioridades, sincronización, autenticación, correo y acceso concurrente desde varios procesos.

**Resultado observable:** tras crear dos tareas y completar una, una nueva ejecución lista exactamente una tarea pendiente y una completada. El usuario puede leer el JSON sin herramientas especiales.

## 3. Recorrido en Kiro IDE

En cada fase usa `egm-elephant` en el espacio de trabajo del laboratorio. Da la orden siguiente **solo después de revisar la salida anterior**. Conserva los archivos; sirven como evidencia de la conexión Kiro–EGM.

| Fase | Mensaje para Elephant | Evidencia esperada |
| --- | --- | --- |
| 1. Contexto | «Lee `LAB.md` y el workspace. Resume hechos, decisiones y preguntas abiertas. No diseñes ni implementes.» | Resumen que identifica un proyecto nuevo sin código. |
| 2. Brainstorm | «Usa `egm-brainstorm` con `LAB.md`. Evalúa alternativas pequeñas y casos límite. Pregunta solo lo indispensable y guarda un concept brief en `docs/egm/briefs/`. Detente.» | Brief con alcance, decisiones y preguntas abiertas. |
| 3. Draft | «Usa `egm-draft` con el brief aprobado para producir un diseño autocontenido en `docs/designs/`. Incluye requisitos identificados, decisiones, formato de datos, errores, criterios de aceptación y pruebas. No escribas código.» | Diseño que permite verificar cada función y caso límite. |
| 4. Review | «Invoca cinco veces a `egm-goldfish` con contexto nuevo: requisitos, arquitectura, seguridad y datos, operaciones, implementación y pruebas. Entrega a cada uno solo el diseño, `LAB.md`, el estándar pertinente y su alcance. Guarda cinco informes distintos en `docs/egm/reviews/`. No corrijas todavía el diseño.» | Cinco invocaciones visibles y cinco informes independientes. |
| 5. Resolve | «Usa `egm-resolve` para clasificar cada hallazgo como aceptado, rechazado con motivo, aplazado o pendiente. Propón los cambios y actualiza el diseño tras mis decisiones. Detente antes de aprobar.» | Registro de resolución y diseño revisado. |
| 6. Aprobación | **La persona** lee el diseño revisado y, si está conforme, escribe: «Apruebo el diseño `[ruta]` para este laboratorio». | Aprobación explícita; una respuesta de Goldfish no cuenta. |
| 7. Kiro Specs | «A partir del diseño aprobado, crea requisitos, diseño y tareas en `.kiro/specs/`. Mapea requisitos a criterios de aceptación y tareas. No implementes aún.» | Specs trazables al diseño. |
| 8. Implementación | «Implementa una tarea aprobada a la vez. Ejecuta pruebas de los casos de aceptación y reporta archivos y resultados.» | CLI funcional y pruebas con resultados. |
| 9. Drift | «Usa `egm-drift-report` para comparar el diseño aprobado, los Specs y el código. Registra cualquier diferencia sin cambiar requisitos por tu cuenta.» | Informe de desvíos, aunque no haya diferencias. |

## 4. Cómo evaluar la conexión

Marca cada punto solo con evidencia observable:

- [ ] Kiro detecta ambos agentes en el workspace aislado.
- [ ] La verificación del setup descrita en README termina sin errores.
- [ ] Elephant encuentra y usa las skills EGM pertinentes.
- [ ] En Review aparecen cinco llamadas reales a `egm-goldfish`, cada una con su tarea separada.
- [ ] Goldfish devuelve hallazgos del diseño y no recibe el historial privado de Elephant ni informes anteriores.
- [ ] Los archivos aparecen en las rutas acordadas y cada fase se detiene donde se pidió.
- [ ] Kiro Specs reflejan el diseño aprobado, sin requisitos nuevos silenciosos.
- [ ] La implementación satisface el resultado observable y el informe de drift compara documentos con código real.

Si una fase falla, conserva el mensaje de error y la actividad del IDE. Corrige esa fase antes de avanzar; un texto que diga «se invocó Goldfish» sin llamada visible no demuestra la invocación.
