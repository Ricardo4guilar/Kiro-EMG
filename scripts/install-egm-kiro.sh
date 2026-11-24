#!/usr/bin/env bash
# Instala / actualiza el Elephant-Goldfish Model (EGM) en un proyecto Kiro.
#
# Uso:
#   scripts/install-egm-kiro.sh [--dry-run] [--force] [--audit-only]
#
#   --dry-run     Muestra lo que haría. No escribe nada.
#   --force       Sobrescribe archivos con ediciones locales (respaldándolos
#                 antes en .kiro/egm-backups/<timestamp>/).
#   --audit-only  Solo audita rutas de las skills instaladas. Sale con 1 si
#                 encuentra referencias rotas.
#
# Variables:
#   PROJECT_ROOT  Raíz del proyecto Kiro (por defecto: padre de scripts/).
#   EGM_SOURCE    Clon de elephant-goldfish-model (por defecto: hermano de
#                 PROJECT_ROOT).
#
# Seguridad de reinstalación:
#   Se guarda un manifiesto con el sha256 de cada archivo instalado en
#   .kiro/egm-upstream/MANIFEST.sha256. En una reinstalación, un archivo cuyo
#   hash difiere del manifiesto se considera editado localmente y NO se
#   sobrescribe salvo con --force. Archivos que no proceden del upstream
#   (p. ej. .kiro/skills/egm-kiro-workflow) nunca se tocan.
set -Eeuo pipefail

DRY_RUN=0; FORCE=0; AUDIT_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    --audit-only) AUDIT_ONLY=1 ;;
    -h|--help) sed -n '2,24p' "$0"; exit 0 ;;
    *) echo "Argumento desconocido: $arg" >&2; exit 2 ;;
  esac
done

log()  { printf '%s\n' "$*"; }
warn() { printf 'AVISO: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
run()  { if (( DRY_RUN )); then log "  [dry-run] $*"; else "$@"; fi; }

# ---------------------------------------------------------------- rutas base
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

if [[ -n "${PROJECT_ROOT:-}" ]]; then
  PROJECT_ROOT="$(cd -- "$PROJECT_ROOT" && pwd -P)" || die "PROJECT_ROOT no existe: $PROJECT_ROOT"
else
  # El script vive en <proyecto>/scripts/. Si hay git y la raíz coincide con
  # ese padre, se usa; si no, se usa el padre del script (sin ambigüedad).
  PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
  if git_root="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
    [[ "$git_root" == "$PROJECT_ROOT" ]] || \
      warn "Raíz git ($git_root) distinta del padre de scripts/ ($PROJECT_ROOT). Se usa esta última; exporta PROJECT_ROOT para cambiarla."
  fi
fi
[[ "$PROJECT_ROOT" != "/" && "$PROJECT_ROOT" != "$HOME" ]] || die "PROJECT_ROOT inseguro: $PROJECT_ROOT"

EGM_SOURCE="${EGM_SOURCE:-$(dirname -- "$PROJECT_ROOT")/elephant-goldfish-model}"
EGM_SOURCE="$(cd -- "$EGM_SOURCE" 2>/dev/null && pwd -P)" || die "EGM_SOURCE no existe. Configura EGM_SOURCE."
[[ "$EGM_SOURCE" != "$PROJECT_ROOT"* ]] || die "EGM_SOURCE no puede estar dentro de PROJECT_ROOT."
for d in skills agents resources docs; do
  [[ -d "$EGM_SOURCE/$d" ]] || die "No encuentro '$d' en EGM_SOURCE=$EGM_SOURCE"
done

cd "$PROJECT_ROOT"
UPSTREAM=".kiro/egm-upstream"
MANIFEST="$UPSTREAM/MANIFEST.sha256"
BACKUP_DIR=".kiro/egm-backups/$(date +%Y%m%d-%H%M%S)"

EGM_VERSION="$(sed -nE 's/^\s*"version":\s*"([^"]+)".*/\1/p' "$EGM_SOURCE/plugin.json" 2>/dev/null | head -1)"
EGM_COMMIT="$(git -C "$EGM_SOURCE" rev-parse --short HEAD 2>/dev/null || echo desconocido)"

log "Proyecto Kiro : $PROJECT_ROOT"
log "Fuente EGM    : $EGM_SOURCE (v${EGM_VERSION:-?}, commit $EGM_COMMIT)"
(( DRY_RUN )) && log "Modo          : dry-run"
log

# ------------------------------------------------------- manifiesto previo
declare -A OLD_HASH=()
if [[ -f "$MANIFEST" ]]; then
  while read -r hash path; do
    [[ -n "$hash" && "$hash" != "#"* ]] && OLD_HASH["$path"]="$hash"
  done < "$MANIFEST"
fi
sha() { sha256sum "$1" | cut -d' ' -f1; }

# Decide si se puede escribir en $1. Devuelve 0 si procede, 1 si se conserva.
SKIPPED=(); BACKED=()
check_local_edit() {
  local dst="$1"
  [[ -f "$dst" ]] || return 0
  local cur; cur="$(sha "$dst")"
  if [[ -z "${OLD_HASH[$dst]:-}" ]]; then
    # Existe pero no está en el manifiesto: instalación antigua o archivo ajeno.
    (( FORCE )) || { SKIPPED+=("$dst (sin manifiesto)"); return 1; }
  elif [[ "${OLD_HASH[$dst]}" != "$cur" ]]; then
    (( FORCE )) || { SKIPPED+=("$dst (editado localmente)"); return 1; }
  else
    return 0  # idéntico a lo instalado: se puede actualizar
  fi
  run mkdir -p "$BACKUP_DIR/$(dirname "$dst")"
  run cp -a "$dst" "$BACKUP_DIR/$dst"
  BACKED+=("$dst")
  return 0
}

# --------------------------------------------- reescritura de rutas (Kiro)
# Las skills quedan en .kiro/skills/<skill>/. Sus referencias a agents/,
# resources/ y docs/ del plugin pasan a .kiro/egm-upstream/ (relativas a la
# raíz del proyecto, que es el cwd de Kiro). references/, docs/designs/ y
# ../sibling/ se dejan intactas porque son correctas.
rewrite_paths() {  # $1 = archivo (in place)
  sed -i -E \
    -e 's#`agents/#`.kiro/egm-upstream/agents/#g' \
    -e 's#`resources/#`.kiro/egm-upstream/resources/#g' \
    -e 's#`docs/(harnesses|codex|claude|getting_started|faq|index)\.md`#`.kiro/egm-upstream/docs/\1.md`#g' \
    -e 's#\]\(\.\./\.\./docs/#](.kiro/egm-upstream/docs/#g' \
    -e 's#\]\(\.\./\.\./TESTING\.md\)#](.kiro/egm-upstream/TESTING.md)#g' \
    -e 's#\$\{CLAUDE_PLUGIN_ROOT\}/#.kiro/egm-upstream/#g' \
    -e 's#"skills/(egm-[a-z-]+)/#".kiro/skills/\1/#g' \
    "$1"
}

# ------------------------------------------------------------ instalación
NEW_MANIFEST_LINES=()
install_file() {  # $1 = origen, $2 = destino, $3 = rewrite(0/1)
  local src="$1" dst="$2" rw="$3"
  check_local_edit "$dst" || return 0
  if (( DRY_RUN )); then
    [[ -f "$dst" ]] && log "  [dry-run] actualizar $dst" || log "  [dry-run] crear     $dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
  if (( rw )); then case "$dst" in *.md|*.yaml|*.yml|*.json) rewrite_paths "$dst" ;; esac; fi
  NEW_MANIFEST_LINES+=("$(sha "$dst")  $dst")
}

install_tree() {  # $1 = origen dir, $2 = destino dir, $3 = rewrite
  local f rel
  while IFS= read -r -d '' f; do
    rel="${f#"$1"/}"
    install_file "$f" "$2/$rel" "$3"
  done < <(find "$1" -type f -print0 | sort -z)
}

do_install() {
  log "1) Copia íntegra del upstream -> $UPSTREAM"
  run mkdir -p "$UPSTREAM" .kiro/skills .kiro/agents .kiro/steering \
      docs/designs docs/egm/reviews docs/egm/briefs
  for d in skills agents resources docs scripts; do
    [[ -d "$EGM_SOURCE/$d" ]] && install_tree "$EGM_SOURCE/$d" "$UPSTREAM/$d" 0
  done
  for f in plugin.json LICENSE README.md TESTING.md; do
    [[ -f "$EGM_SOURCE/$f" ]] && install_file "$EGM_SOURCE/$f" "$UPSTREAM/$f" 0
  done

  log "2) Skills -> .kiro/skills/ (con rutas reescritas para Kiro)"
  local skill_md skill_dir name
  while IFS= read -r -d '' skill_md; do
    skill_dir="$(dirname "$skill_md")"; name="$(basename "$skill_dir")"
    install_tree "$skill_dir" ".kiro/skills/$name" 1
    log "  skill: $name"
  done < <(find "$EGM_SOURCE/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 | sort -z)

  # Archivos del manifiesto previo que se conservaron (saltados) siguen en él.
  if (( ! DRY_RUN )); then
    {
      echo "# EGM upstream v${EGM_VERSION:-?} commit $EGM_COMMIT instalado $(date -Iseconds)"
      echo "# sha256 de cada archivo tal como quedó instalado (tras reescritura)."
      printf '%s\n' "${NEW_MANIFEST_LINES[@]}"
      for p in "${!OLD_HASH[@]}"; do
        printf '%s\n' "${NEW_MANIFEST_LINES[@]}" | grep -qF "  $p" || \
          { [[ -f "$p" ]] && echo "${OLD_HASH[$p]}  $p"; }
      done
    } | sort -k2 -u > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"
  fi

  log
  if (( ${#BACKED[@]} )); then
    log "Respaldados en $BACKUP_DIR (--force):"; printf '  %s\n' "${BACKED[@]}"
  fi
  if (( ${#SKIPPED[@]} )); then
    log "Conservados sin cambios (usa --force para sobrescribir, con respaldo):"
    printf '  %s\n' "${SKIPPED[@]}"
  fi
}

# ----------------------------------------------------------------- auditoría
audit() {
  log "3) Auditoría de rutas en .kiro/skills/"
  local issues=0 f ref target
  # a) patrones del host original que no deben quedar
  while IFS= read -r line; do
    issues=$((issues+1)); log "  RESTO: $line"
  done < <(grep -rnE '`(agents|resources)/|\]\(\.\./\.\./|CLAUDE_PLUGIN_ROOT|"skills/egm-|/home/[a-z]|~/\.|/Users/' \
             .kiro/skills --include='*.md' --include='*.yaml' --include='*.json' 2>/dev/null \
           | grep -v '^.kiro/skills/egm-kiro-workflow/' || true)
  # b) toda ruta .kiro/... o references/... mencionada debe existir
  while IFS=: read -r f _ ref; do
    [[ "$ref" == *"{"* || "$ref" == *"<"* ]] && continue   # plantillas
    case "$ref" in
      .kiro/*) target="$ref" ;;
      references/*) target="$(dirname "$f")/$ref" ;;
    esac
    [[ -e "$target" ]] || { issues=$((issues+1)); log "  ROTA: $f -> $ref"; }
  done < <(grep -rnoE '(\.kiro/egm-upstream|\.kiro/skills|references)/[A-Za-z0-9_./{}<>-]+\.(md|json|yaml)' \
             .kiro/skills --include='*.md' --include='*.yaml' --include='*.json' 2>/dev/null \
           | sed -E 's/^([^:]+):([0-9]+):/\1:\2:/' || true)
  if (( issues )); then
    log "  Auditoría: $issues problema(s)."; return 1
  fi
  log "  Auditoría: sin referencias rotas ni restos del host original."
}

if (( AUDIT_ONLY )); then audit; exit $?; fi
do_install
log
if (( DRY_RUN )); then log "Dry-run terminado. Nada escrito."; exit 0; fi
audit || warn "Revisa las rutas marcadas arriba."
log
log "Instalación completada. Manifiesto: $MANIFEST"
