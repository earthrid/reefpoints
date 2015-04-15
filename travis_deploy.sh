#!/usr/bin/env bash

set -e

git config --global user.email "socko@dockyard.com"
git config --global user.name "sockothesock"


# This specifies the user who is associated to the GH_TOKEN
USER="sockothesock"

# sending output to /dev/null to prevent GH_TOKEN leak on error
git remote rm origin
git remote add origin https://${USER}:${GHTOKEN}@github.com/dockyard/reefpoints.git &> /dev/null


bundle exec rake publish

# Push build/posts.json to homeport.dockyard.com
bundle exec rake build

chmod 600 ./reefpoints_deploy
ssh-keyscan -H homeport.dockyard.com >> ~/.ssh/known_hosts
scp -i ./reefpoints_deploy build/posts.json temp_deploy@homeport.dockyard.com:reefpoints/

echo -e "Done\n"
