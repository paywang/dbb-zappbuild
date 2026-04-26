#!/usr/bin/env bash
set -euo pipefail

echo "Checking local workspace environment..."

if command -v git >/dev/null 2>&1; then
  echo "git: $(git --version)"
  git remote -v || true
else
  echo "git: not found"
fi

if command -v ruby >/dev/null 2>&1; then
  ruby -rjson -e 'JSON.parse(File.read(".vscode/settings.json")); puts "settings.json: OK"' 2>/dev/null || echo "settings.json: missing or invalid"
  ruby -e 'require "yaml"; YAML.load_file("zapp.yaml"); puts "zapp.yaml: OK"' 2>/dev/null || echo "zapp.yaml: missing or invalid"
else
  echo "ruby: not found, skipping JSON/YAML validation"
fi

echo
echo "Workspace files:"
for path in .vscode/settings.json zapp.yaml .gitattributes; do
  if [[ -f "$path" ]]; then
    echo "  found $path"
  else
    echo "  missing $path"
  fi
done

