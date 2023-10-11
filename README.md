#Ansible SentinelOne Provisioning (for OCD)

## Description
This is an unofficial setup tool to provision a new customer within an existing SentinelOne environment using a new Site, Locations etc.

## Docker
All the commands are run form a predefined docker container which runs as follows:
```bash
#executes using current directory
docker run -it --rm -v "${PWD}:/workdir" -w /workdir aio-toolkit /bin/bash
```

Within the container, we leverage existing Ansible Galaxy collections to speed up the process.
```bash
> az login --tenant 1380fd07-5011-46ad-b598-8d50cce415d9
> az group delete --resource-group ... && rm -rf terraform.tfstate && rm -rf .terraform*
> terraform init && terraform apply -auto-approve && terraform output Workstation_admin_password

```
## To Hide GIT History
```bash
git checkout --orphan latest_branch && git add . && git commit -m "Purge Commit History" 
git branch -D main && git branch -m main && git push -f origin main
```