#!/bin/bash -e
# CircleCI Automerge GitHub PR Script

if [ -z "${CIRCLE_PULL_REQUEST}" ]; then
    >&2 echo 'Not in pull request, skipping automerge'
    exit 1
fi

# Ensure all required environment variables are present
if [ -z "$CIRCLE_PROJECT_REPONAME" ] || \
    [ -z "$CIRCLE_BRANCH" ] || \
    [ -z "$CIRCLE_SHA1" ] || \
    [ -z "$GITHUB_SECRET_TOKEN" ] || \
    [ -z "$GIT_COMMITTER_EMAIL" ] || \
    [ -z "$GIT_COMMITTER_NAME" ]; then
    >&2 echo 'Required variable unset, automerging failed'
    exit 1
fi

# Fetch target branch
if [ -n ${CIRCLE_PR_NUMBER} ]; then
    curl -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" -o jq
    chmod +x jq
    url="https://api.github.com/repos/org/repo/pulls/$CIRCLE_PR_NUMBER?access_token=$GITHUB_SECRET_TOKEN"
    target_branch=$(curl "$url" | ./jq '.base.ref' | tr -d '"')
fi

echo : "
Travis-CI automerge pull request script
Repo: $CIRCLE_PROJECT_REPONAME 
Merging: $CIRCLE_BRANCH >> $target_branch 
"

# Clean repo
git clean

# # Checkout full repo
# repo_temp=$(mktemp -d)
# git clone "https://github.com/$TRAVIS_REPO_SLUG" "$repo_temp"
# cd $repo_temp

printf 'Checking out %s\n' "$target_branch"
git checkout "$target_branch"


# Ensure PR commit is head of branch to be merged
branch_head_commit=$(git rev-parse HEAD)
if [ $branch_head_commit != $CIRCLE_SHA1]; then
    >&2 echo "Pull request commit ($CIRCLE_SHA1) and does not match HEAD of branch to be merged ($branch_head_commit), automerge failed"
    exit 1
fi

printf 'Merging %s\n' "$CIRCLE_BRANCH"
git merge "$CIRCLE_SHA1"

printf 'Pushing to %s\n' "$CIRCLE_PROJECT_REPONAME"
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$CIRCLE_PROJECT_REPONAME"

# Push to github to complete merge
# Redirect to /dev/null to avoid secret leakage
git push "$push_uri" "$target_branch" >/dev/null 2>&1
git push "$push_uri" :"$CIRCLE_BRANCH" >/dev/null 2>&1