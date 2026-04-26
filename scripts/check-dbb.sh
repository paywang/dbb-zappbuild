#!/usr/bin/env bash
set -euo pipefail

echo "Checking local DBB/zAppBuild files..."

if [[ ! -f "build.groovy" ]]; then
  echo "ERROR: build.groovy not found. Run this script from the dbb-zappbuild repo root." >&2
  exit 1
fi

if [[ ! -f "build-conf/datasets.properties" ]]; then
  echo "ERROR: build-conf/datasets.properties not found." >&2
  exit 1
fi

echo "Found build.groovy"
echo "Found build-conf/datasets.properties"

echo
echo "Empty required COBOL-related dataset properties:"
awk -F= '/^(SCEELKED|SIGYCOMP_V6|SDFHLOAD|SDFHCOB|SDSNLOAD)=/ && $2=="" { print "  " $1 }' build-conf/datasets.properties

