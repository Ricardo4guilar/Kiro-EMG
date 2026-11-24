# Lab Kiro + EGM

Este proyecto es un laboratorio aislado para aprender cómo se conectan Kiro y el
Elephant–Goldfish Model (EGM) al diseñar una pequeña CLI de tareas. Comienza sin
código de aplicación.

**Para llevar a cabo el laboratorio, sigue [LAB.md](LAB.md) en orden.** Allí están
el objetivo del ejercicio, la comprobación inicial de los agentes en Kiro IDE y
CLI, los mensajes de cada fase y las evidencias que debes revisar antes de avanzar.
Abre `Lab_KiroEMG/` como único workspace en el IDE o trabaja desde su raíz en
la CLI para mantener el ejercicio aislado.

## Preparación y verificación

El paquete EGM y sus ocho skills están incluidos en `.kiro/` como copia instalada.
También están los agentes, el steering común, la skill local `egm-kiro-workflow`
y el manifiesto SHA-256. No hay briefs, diseños, revisiones, Specs ni código de
aplicación; tampoco se copiaron los archivos `product.md`, `tech.md` o
`structure.md` de 4NLab.

Desde este directorio, comprueba la copia incluida:

```bash
bash scripts/verify-lab-setup.sh
```

Debe mostrar «Setup EGM local completo». Un clon de este laboratorio puede
comenzar con esa copia, sin reinstalar EGM.

## Contenido

**Agentes Kiro** (`.kiro/agents/`): `egm-elephant` prepara el contexto y el
diseño, coordina las fases e invoca a `egm-goldfish`. `egm-goldfish` revisa el
diseño en una ejecución separada y devuelve hallazgos; no aprueba ni modifica
el diseño por sí mismo.

**Skills EGM instaladas** (`.kiro/skills/`):

| Skill | Función |
| --- | --- |
| `egm-bootstrap` | Documenta el contexto de un proyecto existente. |
| `egm-brainstorm` | Convierte la idea en un brief de concepto. |
| `egm-draft` | Redacta el diseño a partir del brief. |
| `egm-review` | Organiza la revisión independiente del diseño. |
| `egm-review-loop` | Repite la revisión después de cambios sustanciales. |
| `egm-resolve` | Clasifica y resuelve hallazgos de revisión. |
| `egm-lite` | Aplica un recorrido EGM reducido a cambios pequeños. |
| `egm-drift-report` | Compara diseño y código para informar desvíos. |

**Adaptación Kiro–EGM:** `.kiro/skills/egm-kiro-workflow/` ordena el flujo
completo para Kiro IDE y CLI; `.kiro/steering/egm-workflow.md` fija las reglas,
ubicaciones y aprobación humana. `.kiro/egm-upstream/` conserva las personas,
estándares, documentación y skills originales que se consultan durante el
proceso. `scripts/install-egm-kiro.sh` instala o actualiza esa copia y adapta
sus rutas para Kiro; `scripts/verify-lab-setup.sh` comprueba la integridad de
la instalación incluida.

## Fuente original y reinstalación

Las skills originales proceden de
[`google/elephant-goldfish-model`](https://github.com/google/elephant-goldfish-model).
Para reproducir la instalación desde su origen o actualizar las skills, clona
primero ese repositorio desde GitHub. Desde `Lab_KiroEMG/`, si aún no existe
como carpeta hermana:

```bash
git clone https://github.com/google/elephant-goldfish-model.git ../elephant-goldfish-model
git -C ../elephant-goldfish-model checkout 70406c4
```

El commit `70406c4` es la versión usada para preparar la copia incluida.
Para reinstalar desde ese clon:

```bash
EGM_SOURCE="$PWD/../elephant-goldfish-model" bash scripts/install-egm-kiro.sh
bash scripts/verify-lab-setup.sh
```

La reinstalación no es necesaria para iniciar el ejercicio. Si eliges otra
versión de EGM, revisa los cambios antes de incorporarlos al laboratorio.
Usa `--force` solo si quieres sustituir ediciones locales respaldadas por
el instalador.
