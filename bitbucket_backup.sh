#!/bin/bash

USERNAME="" # BitBucket username
PASSWD="" # App password with API permission (https://support.atlassian.com/bitbucket-cloud/docs/create-an-app-password/)
WORKSPACE_ID="" # Workspace ID
BACKUP_DIR="" # Backup directory

# Find number of repositories
repository_count=$(curl -s -u ${USERNAME}:${PASSWD} -X GET https://api.bitbucket.org/2.0/repositories/${WORKSPACE_ID}?fields=size | jq '.size')
echo "Repository count: ${repository_count}"

# Number of pages
page_count=$((repository_count / 100 + 1))

# Get repositories full name
i=1
while [ $i -le $page_count ]
do
    curl -s -u ${USERNAME}:${PASSWD} "https://api.bitbucket.org/2.0/repositories/${WORKSPACE_ID}?fields=values.full_name&pagelen=100&page=$i" | jq '.values[] | "\(.project.key),\(.full_name)"' >> ${BACKUP_DIR}/repos.csv
    i=$((i+1))
done

# Backup repos
while read -r repo
do
    project=$(echo "${repo}" | cut -d',' -f1)
    repo_name=$(echo "${repo}" | cut -d',' -f2 | cut -d'/' -f2)
    echo "Back-up ${repo} in project ${project}"
    directory="${BACKUP_DIR}/${WORKSPACE_ID}/${project}/${repo_name}"
    if [ -d "${directory}" ]
    then
        echo "Repository backup exists.... Updating backup"
        cd ${directory}
        git remote update
        cd -
    else
        echo "Repository ${repo} backup does not exists... Cloning"
        git clone --bare -q "https://${USERNAME}:${PASSWD}@bitbucket.org/${repo}.git" "${directory}"
    fi
done < ${BACKUP_DIR}/repos.csv

rm -rf ${BACKUP_DIR}/repos.csv