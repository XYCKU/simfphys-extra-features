#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $0 --gmod-directory <path> --gma-path <path> --workshop-item-id <id> --change-note <note>" >&2
}

gmod_directory=""
gma_path=""
workshop_item_id=""
change_note=""

while (( $# > 0 )); do
    case "$1" in
        --gmod-directory|--gma-path|--workshop-item-id|--change-note)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            case "$1" in
                --gmod-directory) gmod_directory="$2" ;;
                --gma-path) gma_path="$2" ;;
                --workshop-item-id) workshop_item_id="$2" ;;
                --change-note) change_note="$2" ;;
            esac
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

if [[ -z "${gma_path}" || ! -f "${gma_path}" ]]; then
    echo "--gma-path must name an existing GMA file." >&2
    exit 2
fi

if [[ ! "${workshop_item_id}" =~ ^[1-9][0-9]*$ ]]; then
    echo "--workshop-item-id must be a positive numeric Workshop ID." >&2
    exit 2
fi

if ! LC_ALL=C grep -Eq '^[ -~]+$' <<<"${change_note}"; then
    echo "--change-note must contain only printable US-ASCII characters." >&2
    exit 2
fi

readonly gmpublish_path="${gmod_directory}/bin/gmpublish_linux"

if [[ ! -x "${gmpublish_path}" ]]; then
    echo "Could not find executable gmpublish_linux at '${gmpublish_path}'." >&2
    exit 2
fi

LD_LIBRARY_PATH="${gmod_directory}/bin${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" \
    "${gmpublish_path}" update \
    -addon "${gma_path}" \
    -id "${workshop_item_id}" \
    -changes "${change_note}"

echo "Published Workshop item ${workshop_item_id}."
