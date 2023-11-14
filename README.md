The bash script in the repository can be used to backup the repositories in a workspace. This can be used by BitBucket admins to run a regular backup of all the repositories in the workspace. 

# SCRIPT USAGE
- Open ```bitbucket_backup.sh``` and add values to the variables:
>  ```
>  - USERNAME : BitBucket username. If the user is an admin or have access to all the repositories, then the backup will contain all the repositories in the workspace.
>  - PASSWD : App password of the user. [App password can be created using this](https://support.atlassian.com/bitbucket-cloud/docs/create-an-app-password/). The App password should have read permission to all the repositories.
>  - WORKSPACE_ID : BitBucket workspace ID.
>  - BACKUP_DIR : Directory where the backup should be present. It can be an absolute path or relative path.
>  ```
- Add execute permission for the script
  ```chmod 755 bitbucket_backup.sh```
- Execute the script
  ```./bitbucket_backup.sh```

> [!NOTE]
> Time for completition of the script depends on the number of repositories present in the workspace. If the number of repositories are more, it's a recommended to run the script in background.