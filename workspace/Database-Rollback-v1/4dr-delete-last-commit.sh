#!/bin/bash
set -e
set -x

# IMPORTANT: 
#  1. in id-PBXjj and id-qQ4MR0f we enable and disable the webhook to avoid
#    triggering a build when we delete the last commit.
#
#  2. In DEPLOY_HOOK_ID might change and make the script fail. If it fails check
#    the IDs match as they are generated in "gitea-entrypoint.sh"

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"


source "../0_scripts/get_repo_dir.sh"
DEVOPS_REPO_DIR=$(get_repo_dir)
DB_REPO_DIR=$(get_app_dir $DEVOPS_REPO_DIR "db-mig") 
echo "[INFO] DEVOPS_REPO_DIR : $DEVOPS_REPO_DIR"
echo "[INFO] DB_REPO_DIR  : $DB_REPO_DIR"


USED_PATH=$(git -C $DB_REPO_DIR rev-parse --show-toplevel)
if [[ ! "$USED_PATH" == *"/db/"* ]]; then
    echo "[ERROR] USED_PATH seems incorrect check path. CAUTION: if the path is bad might revert an upper repo"
    echo "[WARN] repo path to delete last commit: $USED_PATH"
    exit 1;
fi


DEPLOY_HOOK_ID=3
DEPLOY_HOOK_URL="http://gitea:3000/api/v1/repos/$MY_USER/$DB_MIG_NAME/hooks/$DEPLOY_HOOK_ID"

# Disable webhook
echo "[INFO] [id-PBXjj] Disabling webhook temporarily."
curl -s -X PATCH "$DEPLOY_HOOK_URL" \
  -u "$MY_USER:$MY_PASS" \
  -H "Content-Type: application/json" \
  -d '{"active": false}'
sleep 3 # seems that needs a sleep to avoid the webhook to be triggered.

echo "[INFO] [START-cd5mk6lo0] Deleting last commit in repository."
set -x
git -C $DB_REPO_DIR push --force-with-lease origin +main^1:main
set +x
echo "[INFO] [END---cd5mk6lo0] Deleting last commit in repository."



# Re-enable webhook
sleep 3 # seems that needs a sleep to avoid the webhook to be triggered.
echo "[INFO] [id-qQ4MR0f] Re-enabling webhook."
curl -s -X PATCH "$DEPLOY_HOOK_URL" \
  -u "$MY_USER:$MY_PASS" \
  -H "Content-Type: application/json" \
  -d '{"active": true}'


