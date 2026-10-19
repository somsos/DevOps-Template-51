#!/bin/bash
set -e

function add_gitea_to_known_hosts {
    SSH_DIR="/var/jenkins_home/.ssh"
    KNOWN_HOSTS="$SSH_DIR/known_hosts"
    mkdir -p "$SSH_DIR"
    touch "$KNOWN_HOSTS"
    if ssh-keygen -F gitea -f "$KNOWN_HOSTS" > /dev/null; then
        echo "[INFO] gitea already exists in known_hosts"
    else
        echo "[INFO] Adding gitea SSH fingerprint..."

        if ssh-keyscan -p 2222 gitea >> "$KNOWN_HOSTS" 2>/dev/null; then
            echo "[INFO] gitea fingerprint added successfully"
        else
            echo "[WARNING] Could not retrieve gitea SSH fingerprint"
            echo "[WARNING] Jenkins will continue startup"
        fi
    fi
}


function docker_login_to_registry {
    DOCKER_CONFIG_PATH="/root/.docker/config.json"
    REGISTRY="registry.$MY_DOMAIN:$NEXUS_REGISTRY_PORT"

    if grep -q "$REGISTRY" "$DOCKER_CONFIG_PATH" 2>/dev/null; then
        echo "[INFO] Docker credentials for $REGISTRY already exist. Skipping login."
    else
        echo "$MY_PASS" | docker login "$REGISTRY" -u "$MY_USER" --password-stdin && {
            echo "[INFO] Docker login successful."
        } || {
            echo "[WARN] Docker login failed. Please check your credentials and registry status."
        }
    fi
}


# CAUTION: Duplicated code (same name function) in setup/install_functions.sh
function add_buildx_builder {
    if [ -z "$NETWORK_NAME" ]; then
        echo "[ERROR] install.sh->add_buildx_builder required variable NETWORK_NAME not found."
        exit 1
    fi

    if [ -z "$BUILDX_BUILDER" ]; then
        echo "[ERROR] install.sh->add_buildx_builder required variable BUILDX_BUILDER not found."
        exit 1
    fi

    # Check if builder already exists
    if ! docker buildx inspect "$BUILDX_BUILDER" >/dev/null 2>&1; then
        echo "[INFO] Creating Buildx builder: $BUILDX_BUILDER"
        docker buildx create --use \
            --name "$BUILDX_BUILDER" \
            --driver docker-container \
            --driver-opt "network=$NETWORK_NAME"
        docker buildx inspect --bootstrap "$BUILDX_BUILDER"
    else
        echo "[INFO] Buildx builder $BUILDX_BUILDER already exists"
        docker buildx use "$BUILDX_BUILDER"
    fi
}



####### END OF FUNCTION DEFINITIONS #######





docker_login_to_registry

add_gitea_to_known_hosts

add_buildx_builder

exec /usr/bin/tini -- /usr/local/bin/jenkins.sh

