# Github Actions CI/CD workflows

This repo contains our CI/CD Github Actions workflows defined in folder [workflows/](workflows/).
It also syncs the workflows via pull requests to all repositories defined in [.github/syncs.yml][2] (using action [GitHub File Sync][1]).

## Usage

Remember that master branch is protected. So you need to either use *dev* branch or create a new branch for PR's. Don't forget to delete any new branches after you merge them. If you use *dev* it will be automatically reset every time something is merged to master.

### Add repositories into the pipeline

To add a repository that will receive the Github Actions just add your repo to the list in [.github/syncs.yml][2] and when you are done, merge dev branch into master.

A pull request will pop-up in the repository you just added (and should auto-merge).

### Create workflows

Create or modify a yaml file in [workflows/](workflows/). Also update README.md with details about your workflow and remember that this is a public repository.

Push your changes to dev or a separate branch. Once you are done with all your changes. Merge into master.

## Workflows

Descriptions of our current workflows.

### Auto merge workflow syncs

[workflows/auto-merge-syncs.yaml](workflows/auto-merge-syncs.yaml) workflow automatically merges any PR's that comes from this repo.
Since this repo is supposed to be the centralized place for our generic github actions across multiple repositories this would make it easier to manage a lot of repos.

### Auth

[workflows/auth/action.yml](workflows/auth/action.yml) workflow authenticates against our Rancher provisioned k8s clusters, Docker Hub Registry.  
It installs some dependencies like rancher cli, kubectl and more.  
It also sets a `$RELEASE_TAG` environment variable when there is a version tag that starts with v (ex. v1.3.3.7).

#### Auth first-time setup instructions

Currently our Auth workflow uses following organization secrets:

```txt
CONTAINER_REGISTRY
REGISTRY_TOKEN
REGISTRY_USERNAME
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

### Tilt

[workflows/tilt.yaml](workflows/tilt.yaml) workflow executes composite action defined in [workflows/tilt/action.yml](workflows/tilt/action.yml). It install Tilt and dependencies, authenticate against k8s and docker hub (using auth workflow) and finally executes Tilt.

In short running Tilt in a Github Actions CI/CD pipeline.

This workflow depends on the [Auth workflow](#auth). So make sure you have the secrets needed by that workflow.

## Setting up GitHub File Sync for the first time

This repository needs two secrets, `FILE_SYNC_APP_ID` and `FILE_SYNC_APP_PEM` as described in [GitHub File Sync][1].

## Keeping dev and master branch in sync

We have a [GitHub action](.github/sync-dev-branch.yml) that should automatically sync dev branch from the default branch every time there is a push/merge to default branch.

You might need to reset your local dev branch when working on an old copy to avoid merge commits.

```bash
git checkout dev
git fetch origin
git reset --hard origin/dev
```

or execute `./reset-dev.sh`

[1]: https://github.com/marketplace/actions/github-file-sync
[2]: .github/syncs.yml
