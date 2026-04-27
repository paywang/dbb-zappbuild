#!/usr/bin/env bash
set -euo pipefail

if [[ -f "$HOME/.profile" ]]; then
  . "$HOME/.profile"
fi

usage() {
  cat <<'EOF'
Usage:
  run-zappbuild-uss.sh <mode> [build-file-or-list]

Modes:
  user              User build one source file. No MetadataStore build result.
  full              Full build all mapped files.
  impact            Impact build changed and impacted files.
  merge             Merge build changed files flowing back to main.
  scan-source       Full scan of source dependency metadata only.
  scan-all          Full scan of source and load-module dependency metadata.
  preview-full      Full build preview. Does not execute compile/link commands.
  preview-impact    Impact build preview. Does not execute compile/link commands.
  check-datasets    Validate configured system datasets.

Common environment overrides:
  DBB_HOME                  Required. DBB installation directory.
  ZAPPBUILD_DIR             zAppBuild directory. Default: /z/z88589/poc/dbb-zappbuild
  WORKSPACE                 Workspace root on USS. Default: /z/z88589/userbuild
  APPLICATION               Application path relative to WORKSPACE.
                            Default: MortgageApplication/samples/MortgageApplication
  OUT_DIR                   Build output directory. Default: /z/z88589/vscode.logs
  HLQ                       Build dataset high-level qualifier. Default: Z88589
  LOG_ENCODING              Log encoding. Default: UTF-8
  BUILD_FILE                Default source file for user mode.
  PROP_FILES                Optional comma-separated extra property files.
  PROP_OVERWRITES           Optional comma-separated key=value property overrides.
  APPLICATION_CURRENT_BRANCH Optional branch name for pipeline builds.

Examples:
  ./scripts/run-zappbuild-uss.sh user
  ./scripts/run-zappbuild-uss.sh user MortgageApplication/samples/MortgageApplication/cobol/epsnbrvl.cbl
  ./scripts/run-zappbuild-uss.sh full
  ./scripts/run-zappbuild-uss.sh impact
  ./scripts/run-zappbuild-uss.sh preview-impact

EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

mode="${1:-user}"
shift || true

: "${DBB_HOME:?DBB_HOME must be set, for example: export DBB_HOME=/usr/lpp/dbb/v2r0}"

zappbuild_dir="${ZAPPBUILD_DIR:-/z/z88589/poc/dbb-zappbuild}"
workspace="${WORKSPACE:-/z/z88589/userbuild}"
application="${APPLICATION:-MortgageApplication/samples/MortgageApplication}"
out_dir="${OUT_DIR:-/z/z88589/vscode.logs}"
hlq="${HLQ:-Z88589}"
log_encoding="${LOG_ENCODING:-UTF-8}"
default_build_file="${BUILD_FILE:-${application}/cobol/epsnbrvl.cbl}"
build_file="${1:-$default_build_file}"

build_script="${zappbuild_dir}/build.groovy"

if [[ ! -x "${DBB_HOME}/bin/groovyz" ]]; then
  echo "ERROR: ${DBB_HOME}/bin/groovyz not found or not executable." >&2
  exit 1
fi

if [[ ! -f "$build_script" ]]; then
  echo "ERROR: build.groovy not found at $build_script." >&2
  echo "Set ZAPPBUILD_DIR or run this script from the zAppBuild directory." >&2
  exit 1
fi

mkdir -p "$out_dir"

common_args=(
  "$build_script"
  --workspace "$workspace"
  --application "$application"
  --outDir "$out_dir"
  --hlq "$hlq"
  --logEncoding "$log_encoding"
  --verbose
)

if [[ -n "${PROP_FILES:-}" ]]; then
  common_args+=(--propFiles "$PROP_FILES")
fi

if [[ -n "${PROP_OVERWRITES:-}" ]]; then
  common_args+=(--propOverwrites "$PROP_OVERWRITES")
fi

if [[ -n "${APPLICATION_CURRENT_BRANCH:-}" ]]; then
  common_args+=(--applicationCurrentBranch "$APPLICATION_CURRENT_BRANCH")
fi

case "$mode" in
  user)
    if [[ "$build_file" = /* ]]; then
      build_file_check="$build_file"
    else
      build_file_check="${workspace}/${build_file}"
    fi
    if [[ ! -f "$build_file_check" ]]; then
      echo "ERROR: build file not found: $build_file_check" >&2
      echo "The build file must be relative to WORKSPACE or an absolute USS path." >&2
      echo "Current WORKSPACE is: $workspace" >&2
      echo "Current APPLICATION is: $application" >&2
      exit 1
    fi
    build_args=(--userBuild "$build_file")
    ;;
  full)
    build_args=(--fullBuild)
    ;;
  impact)
    build_args=(--impactBuild)
    ;;
  merge)
    build_args=(--mergeBuild)
    ;;
  scan-source)
    build_args=(--fullBuild --scanSource)
    ;;
  scan-all)
    build_args=(--fullBuild --scanAll)
    ;;
  preview-full)
    build_args=(--fullBuild --preview)
    ;;
  preview-impact)
    build_args=(--impactBuild --preview)
    ;;
  check-datasets)
    build_args=(--impactBuild --checkDatasets)
    ;;
  *)
    echo "ERROR: unknown mode '$mode'." >&2
    usage >&2
    exit 2
    ;;
esac

echo "Running zAppBuild mode: $mode"
echo "  DBB_HOME:      $DBB_HOME"
echo "  zAppBuild:     $zappbuild_dir"
echo "  workspace:     $workspace"
echo "  application:   $application"
echo "  outDir:        $out_dir"
echo "  hlq:           $hlq"
if [[ "$mode" == "user" ]]; then
  echo "  build file:    $build_file"
fi
echo

cd "$zappbuild_dir"
exec "${DBB_HOME}/bin/groovyz" "${common_args[@]}" "${build_args[@]}"
