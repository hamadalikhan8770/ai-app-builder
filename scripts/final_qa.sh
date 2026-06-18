#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "== Flutter analyze =="
flutter analyze
echo "== Flutter test =="
flutter test
echo "== Web build =="
(cd web && npm run build)
echo "== Done =="
