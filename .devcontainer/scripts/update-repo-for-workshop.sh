#!/bin/bash
workspace="/workspaces/$(basename ${GITHUB_REPOSITORY})"

## Check to see if you're in the right path
## This protects against updating the template while working on the template repo.
## TODO: This will fail if users are doing this "outside" of GitHub. Need a way to "normalize it"
if [[ ! -d ${workspace} ]] ; then
    echo "FATAL: Unable to verify current working directory"
    exit 3
fi

## Check to see if the ${GITHUB_REPOSITORY} env is set (best effort)
## TODO: This will fail if users are doing this "outside" of GitHub. Need a way to "normalize it"
if [[ -z ${GITHUB_REPOSITORY} ]] ; then
    echo "FATAL: The GITHUB_REPOSITORY env var is not set"
    exit 3
fi

## Search for <repo> and replace it with $GITHUB_REPOSITORY
find ${workspace} -name '*.yaml' -type f -exec grep -l '<repo>' {} \; | while read file
do
    sed -i "s?<repo>?${GITHUB_REPOSITORY}?g" ${file}
done

## Search for argadepp and replace it with $GITHUB_USER
find ${workspace} -name '*.yaml' -type f -exec grep -l 'argadepp' {} \; | while read imagefile
do
    sed -i "s?argadepp?${GITHUB_USER}?g" ${imagefile}
done

## Now that the files are updated, we commit it and push it up. Best effort :cross_fingers_emoji:
cd ${workspace}
git add .
git commit -am "updated source to point to ${GITHUB_USER}"
git push origin main

## Exit with 0 for the post-start script
exit 0
