#!/usr/bin/env bash
# Verifica el paquete EGM versionado en este laboratorio sin necesitar el clon fuente.
set -Eeuo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$PROJECT_ROOT"

for file in LAB.md \
  .kiro/agents/egm-elephant.md .kiro/agents/egm-goldfish.md \
  .kiro/steering/egm-workflow.md \
  .kiro/skills/egm-kiro-workflow/SKILL.md \
  .kiro/egm-upstream/MANIFEST.sha256; do
  [[ -f "$file" ]] || { echo "Falta: $file" >&2; exit 1; }
done

for skill in egm-bootstrap egm-brainstorm egm-draft egm-drift-report \
  egm-lite egm-resolve egm-review egm-review-loop; do
  [[ -f ".kiro/skills/$skill/SKILL.md" ]] || {
    echo "Falta la skill: $skill" >&2
    exit 1
  }
done

sha256sum -c .kiro/egm-upstream/MANIFEST.sha256 --quiet

for unexpected in product.md tech.md structure.md; do
  [[ ! -e ".kiro/steering/$unexpected" ]] || {
    echo "Steering ajeno a este laboratorio: $unexpected" >&2
    exit 1
  }
done

echo "Setup EGM local completo; manifiesto y ocho skills verificados."
