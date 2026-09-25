#!/bin/bash
set -e

# IMPORTANT: 
#  1. in id-PBXjj and id-qQ4MR0f we enable and disable the webhook to avoid
#    triggering a build when we delete the last commit.
#
#  2. In DEPLOY_HOOK_ID might change and make the script fail. If it fails check
#    the IDs match as they are generated in "gitea-entrypoint.sh"
#

source "../0_scripts/get_environment.sh"
ENV=$(get_environment)
source "../0_scripts/check_necessary_variables.sh"
check_necessary_variables "$ENV"

source "../0_scripts/get_repo_dir.sh"
REPO_DIR=$(get_repo_dir)

FRONT_REPO_DIR="$REPO_DIR/app/front/source"
echo "[INFO] REPO_DIR      : $REPO_DIR"
echo "[INFO] FRONT_REPO_DIR : $FRONT_REPO_DIR"


git -C $FRONT_REPO_DIR log --oneline -n2 --format=%s > ./temp1.txt
TO_DELETE=$(head -n1 temp1.txt)
TO_RE_DEPLOY=$(tail -n1 temp1.txt)
rm ./temp1.txt

echo -e "\033[38;5;27;48;5;231m[INFO] TO_DELETE     : $TO_DELETE\033[0m"
echo -e "\033[38;5;27;48;5;231m[INFO] TO_RE_DEPLOY  : $TO_RE_DEPLOY\033[0m"

# Checking path
# CAUTION: It happened me that as the path was wrong the command did a revert
# in the wrong path

USED_PATH=$(git -C $FRONT_REPO_DIR rev-parse --show-toplevel)
if [[ ! "$USED_PATH" == *"/front/"* ]]; then
    echo "[ERROR] USED_PATH seems incorrect check path. CAUTION: if the path is bad might revert an upper repo"
    exit 1;
fi

echo "[INFO] Last commit backup created."
mv $FRONT_REPO_DIR $FRONT_REPO_DIR-backup


DEPLOY_HOOK_ID=2
DEPLOY_HOOK_URL="http://gitea:3000/api/v1/repos/$MY_USER/$FRONT_NAME/hooks/$DEPLOY_HOOK_ID"
# Disable webhook
echo "[INFO] [id-PBXjj] Disabling webhook temporarily."
curl -s -X PATCH "$DEPLOY_HOOK_URL" \
  -u "$MY_USER:$MY_PASS" \
  -H "Content-Type: application/json" \
  -d '{"active": false}'
sleep 3 # seems that needs a sleep to avoid the webhook to be triggered.


echo "[INFO] [START-1cg3oi7] Deleting last commit in repository."
set -x
git -C $FRONT_REPO_DIR-backup push --force-with-lease origin +main^1:main
set +x
echo "[INFO] [END---1cg3oi7 Deleting last commit in repository."



# Re-enable webhook
sleep 3 # seems that needs a sleep to avoid the webhook to be triggered.
echo "[INFO] [id-qQ4MR0f] Re-enabling webhook."
curl -s -X PATCH "$DEPLOY_HOOK_URL" \
  -u "$MY_USER:$MY_PASS" \
  -H "Content-Type: application/json" \
  -d '{"active": true}'


