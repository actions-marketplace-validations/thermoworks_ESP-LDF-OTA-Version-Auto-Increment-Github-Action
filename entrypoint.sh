#!/bin/sh -l
set -e

file_name="version.txt"

echo "Git Head Ref: ${GITHUB_HEAD_REF}"
echo "Git Base Ref: ${GITHUB_BASE_REF}"
echo "Git Event Name: ${GITHUB_EVENT_NAME}"

echo "\nStarting Git Operations"
git config --global user.email "esp32-ota-version-increment@github-action.com"
git config --global user.name "esp32-ota-version-increment App"

github_ref=""

if test "${GITHUB_EVENT_NAME}" = "push"
then
    github_ref=${GITHUB_REF}
else
    github_ref=${GITHUB_HEAD_REF}
    git checkout $github_ref
fi


echo "Git Checkout"

content=$(cat $file_name)
echo "File Content: $content"
current_version=$(echo $content | awk '/^([[:space:]])*([[:blank:]])*([0-9]{1,2})[[:space:]]*$/{print $0}')
echo "Extracted string: $current_version"

if [[ "$current_version" == "" ]]; then 
    echo "\nInvalid version string"
    exit 1
else
    echo "\nValid version string found"
fi

new_version=$(echo $current_version | cut -d'.' -f1) 

oldver=$(echo $new_version)
new_version=$(expr $new_version + 1)
newver=$(echo $new_version)

echo "\nOld Ver: $oldver"
echo "\nUpdated version: $newver" 

newcontent=$(echo ${content/$oldver/$newver})
echo $newcontent > $file_name

git add -A 
git commit -m "Incremented to ${newver}"  -m "[skip ci]"
([ -n "$tag_version" ] && [ "$tag_version" = "true" ]) && (git tag -a "${newver}" -m "[skip ci]") || echo "No tag created"

git show-ref
echo "Git Push"

git push --follow-tags "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" HEAD:$github_ref


echo "\nEnd of Action\n\n"
exit 0