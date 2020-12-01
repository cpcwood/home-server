
#!/bin/bash -e
# TravisCI Automerge PR Script

if [[ -z ${$TRAVIS_REPO_SLUG+x} || \
    -z ${$TRAVIS_PULL_REQUEST_BRANCH+x} || \
    -z ${$TRAVIS_BRANCH+x} || \
    -z ${$TRAVIS_PULL_REQUEST_SHA+x} || \
    -z ${$GITHUB_SECRET_TOKEN+x} || \
    -z ${$GIT_COMMITTER_EMAIL+x} || \
    -z ${$GIT_COMMITTER_NAME+x} ]]; then
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

printf 'Merging %s\n' "$TRAVIS_PULL_REQUEST_BRANCH"
commit_messsage="TRAVIS-CI auto-merge $TRAVIS_PULL_REQUEST_BRANCH into $TRAVIS_BRANCH"
git merge -m "$commit_messsage" "$TRAVIS_PULL_REQUEST_SHA"

printf 'Pushing to %s\n' "$TRAVIS_REPO_SLUG"
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$TRAVIS_REPO_SLUG"

# Redirect to /dev/null to avoid secret leakage
git push "$push_uri" "$TRAVIS_BRANCH" >/dev/null 2>&1