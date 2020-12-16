#!/bin/bash -e
# CircleCI Automerge GitHub Pull Request Script

# Ensure in PR
if [ -z "$CIRCLE_PULL_REQUEST" ]; then
    >&2 echo 'Not in pull request, skipping automerge'
    exit 1
fi

# Ensure all required environment variables are present
if [ -z "$CIRCLE_PROJECT_REPONAME" ] || \
    [ -z "$CIRCLE_PROJECT_USERNAME" ] || \
    [ -z "$CIRCLE_PULL_REQUEST" ] || \
    [ -z "$CIRCLE_BRANCH" ] || \
    [ -z "$CIRCLE_SHA1" ] || \
    [ -z "$GITHUB_SECRET_TOKEN" ]; then
    >&2 echo 'Required variable unset, automerging failed'
    exit 1
fi

# Extract GitHub PR number
github_pr_number="$(echo "$CIRCLE_PULL_REQUEST" | sed -n 's/^.*\/\([0-9]\+\)$/\1/p')"
if [ -z "$github_pr_number" ] || \
    >&2 echo 'GitHub PR number not found'
    exit 1
fi

# Fetch target branch name
curl -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" -o jq
chmod +x jq
url="https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$github_pr_number"
target_branch=$(curl -H "Authorization: $GITHUB_SECRET_TOKEN" "$url" | ./jq '.base.ref' | tr -d '"')
if [ -z "$target_branch" ] || \
    >&2 echo 'Failed to fetch GitHub PR target branch'
    exit 1
fi

echo : "
CircleCI Automerge Pull Request
Repo: $CIRCLE_PROJECT_REPONAME
Pull Request: $github_pr_number
Merging: $CIRCLE_BRANCH >> $target_branch 
"

# Merge PR via GitHub API
curl \
  -X PUT \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: $GITHUB_SECRET_TOKEN" \
  "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls/$github_pr_number/merge" \
  -d '{"commit_title":"CircleCI automerge '"$CIRCLE_BRANCH >> $target_branch"'", "sha": "'"$CIRCLE_SHA1"'"}'