#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly image_name="${GMOD_RUNTIME_IMAGE:-sef-gmod-runtime:ci}"
readonly server_volume="${GMOD_DOCKER_SERVER_VOLUME:-sef-gmod-runtime-server}"
readonly steam_volume="${GMOD_DOCKER_STEAM_VOLUME:-sef-gmod-runtime-steam}"
readonly log_directory="${repository_root}/artifacts"

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required to run the GMod runtime checks." >&2
    exit 2
fi

if ! docker info >/dev/null 2>&1; then
    echo "Docker is installed but its daemon is unavailable." >&2
    exit 2
fi

mkdir -p "${log_directory}"
docker volume create "${server_volume}" >/dev/null
docker volume create "${steam_volume}" >/dev/null

docker build \
    --tag "${image_name}" \
    --file "${repository_root}/docker/gmod-runtime/Dockerfile" \
    "${repository_root}/docker/gmod-runtime"

docker run --rm \
    --mount "type=bind,source=${repository_root},target=/workspace,readonly" \
    --mount "type=bind,source=${log_directory},target=/workspace/artifacts" \
    --mount "type=volume,source=${server_volume},target=/srv/gmod" \
    --mount "type=volume,source=${steam_volume},target=/home/steam/Steam" \
    "${image_name}"
