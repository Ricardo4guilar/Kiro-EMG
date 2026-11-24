# Lab Kiro + EGM

Laboratorio aislado para aprender el flujo Elephant–Goldfish Model en Kiro mediante
el diseño de una CLI pequeña de tareas. El proyecto empieza sin código de aplicación.

Abre `Lab_KiroEMG/` como único workspace en Kiro IDE. Inicia un chat nuevo y
comprueba que estén disponibles `egm-elephant` y `egm-goldfish`. Si aparecen
reglas globales ajenas, revísalas antes de la prueba. Consulta [LAB.md](LAB.md)
para el objetivo concreto, los mensajes de cada fase y los criterios de evaluación.

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
