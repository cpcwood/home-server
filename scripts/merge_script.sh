
#!/bin/bash -e
: "
Repo: $TRAVIS_REPO_SLUG 
Merging: $TRAVIS_BRANCH << $TRAVIS_PULL_REQUEST_BRANCH
User: $GIT_COMMITTER_EMAIL $GIT_COMMITTER_NAME
"

# Checkout full repo
repo_temp=$(mktemp -d)
git clone "https://github.com/$TRAVIS_REPO_SLUG" "$repo_temp"
cd $repo_temp

printf 'Checking out %s\n' $TRAVIS_BRANCH
git checkout $TRAVIS_BRANCH

printf 'Merging %s\n' $TRAVIS_PULL_REQUEST_BRANCH
commit_messsage="TRAVIS-CI auto-merge $TRAVIS_PULL_REQUEST_BRANCH into $TRAVIS_BRANCH"
git merge -m $commit_messsage $TRAVIS_PULL_REQUEST_BRANCH

printf 'Pushing to %s\n' $TRAVIS_REPO_SLUG
push_uri="https://$GITHUB_SECRET_TOKEN@github.com/$TRAVIS_REPO_SLUG"

# Redirect to /dev/null to avoid secret leakage
git push $push_uri $BRANCH_TO_MERGE_INTO >/dev/null 2>&1