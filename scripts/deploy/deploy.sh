#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

SOURCE_BRANCH="dev"
TARGET_BRANCH="gh-pages"

# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Building demo-app"
    gulp build:devapp
    exit 0
fi

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into deploy/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deply)
git clone $REPO deploy
cd deploy
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Clean deploy existing contents
rm -rf deploy/**/* || exit 0

# Compile demo-app
gulp build:devapp
gulp deploy

# Now let's go have some fun with the cloned repo
cd deploy
git config user.name "dharmeshpipariya"
git config user.email "dharmeshpipariya@gmail.com"

# If there are no changes (e.g. this is a README update) then just bail.
if [ -z `git diff --exit-code` ]; then
    echo "Demo already updated."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .
git commit -m "Update demo: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
#openssl aes-256-cbc -K $encrypted_fd9859267a7e_key -iv $encrypted_fd9859267a7e_iv -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH
