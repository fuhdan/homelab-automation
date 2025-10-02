#!/bin/bash

if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_OWNER" ] || [ -z "$GITHUB_REPO" ]; then
    echo "Error: GITHUB_TOKEN, GITHUB_OWNER, and GITHUB_REPO must be set"
    exit 1
fi

RUNNER_NAME=${RUNNER_NAME:-"docker-runner-$(hostname)"}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,linux,x64"}

# Configure the runner
./config.sh \
    --url https://github.com/${GITHUB_OWNER}/${GITHUB_REPO} \
    --token ${GITHUB_TOKEN} \
    --name ${RUNNER_NAME} \
    --labels ${RUNNER_LABELS} \
    --unattended \
    --replace

# Cleanup function
cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${GITHUB_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Run the runner
./run.sh & wait $!