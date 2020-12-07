
#!/bin/bash -ev
# TravisCI Automerge PR Script

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    >&2 echo 'Not in pull request, skipping automerge'
    exit 1
fi

# Ensure all required environment variables are present
if [ -z "$TRAVIS_REPO_SLUG" ] || \
    [ -z "$TRAVIS_PULL_REQUEST_BRANCH" ] || \
    [ -z "$TRAVIS_BRANCH" ] || \
    [ -z "$TRAVIS_PULL_REQUEST_SHA" ] || \
    [ -z "$GITHUB_SECRET_TOKEN" ] || \
    [ -z "$GIT_COMMITTER_EMAIL" ] || \
    [ -z "$GIT_COMMITTER_NAME" ]; then
    >&2 echo 'Required variable unset, automerging failed'
    exit 1
fi

echo : "
Travis-ci automerge pull request script
Repo: $TRAVIS_REPO_SLUG 
Merging: $TRAVIS_PULL_REQUEST_BRANCH >> $TRAVIS_BRANCH 
"

# Checkout full repo
repo_temp=$(mktemp -d)
git clone "https://github.com/$TRAVIS_REPO_SLUG" "$repo_temp"
cd $repo_temp

printf 'Checking out %s\n' "$TRAVIS_BRANCH"
git checkout "$TRAVIS_BRANCH"

# Ensure checkout commit is the same as the tested PR commit
current_commit="${git rev-parse --short HEAD}"
if [ "$current_commit" != "$TRAVIS_PULL_REQUEST_SHA"]; then
    >&2 echo "Pull request commit '$TRAVIS_PULL_REQUEST_SHA' and merge '$current_commit' commit do not match, automerge failed"
    exit 1
fi

>&2 echo "Pull request commit '$TRAVIS_PULL_REQUEST_SHA' and merge '$current_commit' commit do not match, automerge failed"

# printf 'Merging %s\n' "$TRAVIS_PULL_REQUEST_BRANCH"
# git merge "$TRAVIS_PULL_REQUEST_SHA"

# printf 'Pushing to %s\n' "$TRAVIS_REPO_SLUG"
# push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$TRAVIS_REPO_SLUG"

# # Push to github to complete merge
# # Redirect to /dev/null to avoid secret leakage
# git push "$push_uri" "$TRAVIS_BRANCH" >/dev/null 2>&1
# git push "$push_uri" :"$TRAVIS_PULL_REQUEST_BRANCH" >/dev/null 2>&1