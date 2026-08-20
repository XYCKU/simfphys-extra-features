#!/usr/bin/env bash
set -euo pipefail

readonly server_directory="${GMOD_SERVER_DIRECTORY:-/srv/gmod}"
readonly source_directory="${SEF_SOURCE_DIRECTORY:-/workspace}"
readonly log_directory="${SEF_LOG_DIRECTORY:-/workspace/artifacts}"
readonly timeout_seconds="${GMOD_TEST_TIMEOUT_SECONDS:-120}"
readonly stage_directory="${server_directory}/garrysmod/addons/sef-ci"
readonly stage_marker_path="${stage_directory}/.sef-ci-generated"
readonly log_path="${log_directory}/gmod-tests.log"

if [[ ! "${timeout_seconds}" =~ ^[0-9]+$ ]] || (( timeout_seconds < 30 || timeout_seconds > 300 )); then
    echo "GMOD_TEST_TIMEOUT_SECONDS must be an integer between 30 and 300." >&2
    exit 2
fi

for required_path in \
    "${source_directory}/lua/sef" \
    "${source_directory}/lua/autorun/sef_init.lua" \
    "${source_directory}/tests/gmod/sef_ci.lua"; do
    if [[ ! -e "${required_path}" ]]; then
        echo "Required GMod test source is missing: '${required_path}'." >&2
        exit 2
    fi
done

install -d -o steam -g steam "${server_directory}" "/home/steam/Steam"
mkdir -p "${log_directory}"

if [[ ! -x "${server_directory}/srcds_run" ]]; then
    runuser -u steam -- /home/steam/steamcmd/steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +force_install_dir "${server_directory}" \
        +login anonymous \
        +app_update 4020 validate \
        +quit
else
    runuser -u steam -- /home/steam/steamcmd/steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +force_install_dir "${server_directory}" \
        +login anonymous \
        +app_update 4020 \
        +quit
fi

if [[ ! -x "${server_directory}/srcds_run" ]]; then
    echo "Garry's Mod dedicated server installation did not provide srcds_run." >&2
    exit 2
fi

if [[ -d "${stage_directory}" ]]; then
    if [[ ! -f "${stage_marker_path}" ]]; then
        echo "Refusing to remove '${stage_directory}' because it is not a previous SEF CI stage." >&2
        exit 2
    fi

    rm -rf -- "${stage_directory}"
fi

cleanup_stage() {
    if [[ -f "${stage_marker_path}" ]]; then
        rm -rf -- "${stage_directory}"
    fi
}
trap cleanup_stage EXIT

mkdir -p \
    "${stage_directory}/lua/autorun/server" \
    "${stage_directory}/lua/tests"
touch "${stage_marker_path}"

cp -R "${source_directory}/lua/sef" "${stage_directory}/lua/sef"
cp "${source_directory}/lua/autorun/sef_init.lua" "${stage_directory}/lua/tests/sef_init.lua"
cp "${source_directory}/tests/gmod/sef_ci.lua" "${stage_directory}/lua/autorun/server/zz_sef_ci.lua"
chown -R steam:steam "${stage_directory}"

rm -f -- "${log_path}"
set +e
timeout --kill-after=10s "${timeout_seconds}s" \
    runuser -u steam -- "${server_directory}/srcds_run" \
    -game garrysmod \
    -console \
    -noconclr \
    -norestart \
    -allowquit \
    -noworkshop \
    +gamemode sandbox \
    +map gm_construct >"${log_path}" 2>&1
server_exit_code=$?
set -e

cat "${log_path}"

if grep -q "\[SEF CI\] FAIL" "${log_path}"; then
    echo "GMod server tests reported a failure. See artifacts/gmod-tests.log." >&2
    exit 1
fi

if ! grep -Eq "\[SEF CI\] PASS [0-9]+ assertions" "${log_path}"; then
    echo "GMod server tests did not report completion. See artifacts/gmod-tests.log." >&2
    exit 1
fi

if (( server_exit_code != 0 )); then
    echo "Dedicated server exited with code ${server_exit_code}. See artifacts/gmod-tests.log." >&2
    exit 1
fi

echo "GMod server tests passed."
