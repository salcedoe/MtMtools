#!/usr/bin/env bash
#
# publish_toolbox.sh
#
# Mirrors MtMtoolbox/ (the versioned source of truth in this repo) into the
# shared MATLAB Drive folder the class has access to. One-way, source -> Drive
# only. Never edit files inside the Drive copy directly; they will be
# overwritten on the next publish.
#
# Usage:
#   scripts/publish_toolbox.sh            # publish
#   scripts/publish_toolbox.sh --dry-run  # show what would change, no writes

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/MtMtoolbox/"
DEST="/Users/ernesto/MATLAB-Drive/MtMresources/toolbox/"

# Safety rail: refuse to run --delete against a path that isn't clearly the
# intended MATLAB Drive destination. Cheap insurance against a typo'd DEST
# wiping the wrong folder.
case "$DEST" in
  */MATLAB-Drive/*) ;;
  *)
    echo "Refusing to publish: DEST does not look like a MATLAB Drive path: $DEST" >&2
    exit 1
    ;;
esac

mkdir -p "$DEST"

RSYNC_FLAGS=(-av --delete
  --exclude=".git/"
  --exclude=".gitignore"
  --exclude=".gitattributes"
  --exclude=".DS_Store"
  --exclude=".MATLABDriveTag"
)

if [[ "${1:-}" == "--dry-run" ]]; then
  RSYNC_FLAGS+=(--dry-run -v)
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Publishing $SRC -> $DEST"
rsync "${RSYNC_FLAGS[@]}" "$SRC" "$DEST"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Done."
