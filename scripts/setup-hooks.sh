set -euo pipefail
git config core.hooksPath .githooks
echo "✅ Hooks enabled (core.hooksPath=.githooks)"
