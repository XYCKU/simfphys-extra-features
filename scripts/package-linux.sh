#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 --gmod-directory <path> [--package-name <name>]" >&2
}

gmod_directory=""
package_name="simfphys-extra-features"

while (( $# > 0 )); do
    case "$1" in
        --gmod-directory)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            gmod_directory="$2"
            shift 2
            ;;
        --package-name)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            package_name="$2"
            shift 2
            ;;
        *)
            usage
            exit 2
            ;;
    esac
done

if [[ -z "${gmod_directory}" || ! -d "${gmod_directory}" ]]; then
    echo "--gmod-directory must name an existing Garry's Mod directory." >&2
    exit 2
fi

if [[ ! "${package_name}" =~ ^[a-z0-9][a-z0-9._-]*$ ]]; then
    echo "--package-name may contain only lowercase letters, digits, dots, underscores, and hyphens." >&2
    exit 2
fi

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly artifacts_directory="${repository_root}/artifacts"
readonly stage_directory="${artifacts_directory}/package-stage"
readonly gma_path="${artifacts_directory}/${package_name}.gma"
readonly checksum_path="${gma_path}.sha256"
readonly gmad_path="${gmod_directory}/bin/gmad_linux"
readonly metadata_path="${repository_root}/addon.json"

if [[ ! -x "${gmad_path}" ]]; then
    echo "Could not find executable gmad_linux at '${gmad_path}'." >&2
    exit 2
fi

if [[ ! -f "${metadata_path}" ]]; then
    echo "Could not find addon.json at '${metadata_path}'." >&2
    exit 2
fi

if ! python3 -m json.tool "${metadata_path}" >/dev/null; then
    echo "addon.json must contain valid JSON." >&2
    exit 2
fi

rm -rf -- "${stage_directory}"
mkdir -p "${stage_directory}"

for directory in lua materials resource; do
    if [[ ! -d "${repository_root}/${directory}" ]]; then
        echo "Required addon directory is missing: '${directory}'." >&2
        exit 2
    fi

    cp -R "${repository_root}/${directory}" "${stage_directory}/${directory}"
done

cp "${metadata_path}" "${stage_directory}/addon.json"

LD_LIBRARY_PATH="${gmod_directory}/bin${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" \
    "${gmad_path}" create -folder "${stage_directory}" -out "${gma_path}"

if [[ ! -f "${gma_path}" ]]; then
    echo "gmad_linux did not create '${gma_path}'." >&2
    exit 1
fi

checksum="$(sha256sum "${gma_path}" | awk '{print $1}')"
printf '%s *%s.gma' "${checksum}" "${package_name}" >"${checksum_path}"

echo "Created ${gma_path}"
echo "Created ${checksum_path}"
