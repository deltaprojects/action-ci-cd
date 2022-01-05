# Github Actions CI/CD workflows

This repo contains our CI/CD Github Actions workflows defined in folder [workflows/](workflows/).
It also syncs the workflows via pull requests to all repositories defined in [.github/syncs.yml][2] (using action [GitHub File Sync][1]).

## Usage

### Add repositories into the pipeline

To add a repository that will receive the Github Actions just add your repo to the list in [.github/syncs.yml][2] and when you are done, merge dev branch into master.

A pull request will pop-up in the repository you just added (and should auto-merge).

### Create workflows

Create or modify a yaml file in [workflows/](workflows/). Also update README.md with details about your workflow and remember that this is a public repository.

Push your changes to dev branch. Once you are done with all your changes. Merge into master.

## Workflows

Descriptions of our current workflows.

### Tilt

[workflows/tilt.yaml](workflows/tilt.yaml) workflow executes composite action defined in [workflows/tilt/action.yml](workflows/tilt/action.yml). It install Tilt and dependencies, authenticate against k8s and docker hub and finally executes Tilt.

In short running Tilt in a Github Actions CI/CD pipeline.

#### Tilt first-time setup instructions

Currently our Tilt workflow uses following organization secrets:

```txt
DOCKER_HUB_ACCESS_TOKEN
DOCKER_HUB_USERNAME
RANCHER_CONTEXT
RANCHER_TOKEN
RANCHER_URL
```

Also we use rancher to authenticate. But in the future we could be using another Kubernetes distribution. So in that case we would need a `KUBE_CONFIG` secret.

Anyways here are the instructions to create the needed secrets

**Rancher secrets**  
To create a API key, login to Rancher Web UI and click your profile -> API & Keys.  
Create a new key with no scope. Put Bearer Token in GitHub secret RANCHER_TOKEN and Endpoint URL as RANCHER_URL.  
To select context run `rancher context switch` and copy the PROJECT ID into GitHub secret RANCHER_CONTEXT.  

**kube-config secret**  
Then run `kubectl config view --minify -o yaml --raw | base64` to export.  
Put this into a secret named KUBE_CONFIG in GitHub.  

## Setting up GitHub File Sync for the first time

This repository needs two secrets, `FILE_SYNC_APP_ID` and `FILE_SYNC_APP_PEM` as described in [GitHub File Sync][1].

## Keeping dev and master branch in sync

We have a GitHub action that should automatically sync dev branch from the default branch every time there is a push, [.github/sync-dev-branch.yml](.github/sync-dev-branch.yml).

[1]: https://github.com/marketplace/actions/github-file-sync
[2]: .github/syncs.yml
