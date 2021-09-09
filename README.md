# Github Actions + Tilt CI/CD

This repo contains our CI/CD Github Actions workflows for running Tilt in a Github Actions CI/CD pipeline defined in folder [workflows/](workflows/).
It also syncs the workflows via pull requests to all repositories defined in [.github/syncs.yml][2] using action [jetersen/ghaction.file.sync][1].

## Usage

### To modify how the the workflow works

Modify [workflows/build-and-deploy.yaml](workflows/build-and-deploy.yaml) to update the workflow.

Push your changes to dev branch. Once you are done with all your changes. Merge into master.

### Add repositories into the pipeline

To add a repository that will receive the Github Actions just add your repo to the list in [.github/syncs.yml][2] and when you are done, merge dev branch into master.

A pull request will pop-up in the repository you just added (and should auto-merge).

## Initial setup

This repository needs two secrets, `FILE_SYNC_APP_ID` and `FILE_SYNC_APP_PEM` as described in [jetersen/ghaction.file.sync][1].
And currently our Tilt workflow uses following organization secrets:

```txt
DOCKER_HUB_ACCESS_TOKEN
DOCKER_HUB_USERNAME
RANCHER_CONTEXT
RANCHER_TOKEN
RANCHER_URL
```

Currently we use rancher to authenticate. But in the future we could be using another Kubernetes distribution. So in that case we would need a `KUBE_CONFIG` secret

Anyways here are the instructions to create the needed secrets

**Rancher secrets**  
To create a API key, login to Rancher Web UI and click your profile -> API & Keys.  
Create a new key with no scope. Put Bearer Token in GitHub secret RANCHER_TOKEN and Endpoint URL as RANCHER_URL.  
To select context run `rancher context switch` and copy the PROJECT ID into GitHub secret RANCHER_TOKEN.  

**kube-config secret**  
Then run `kubectl config view --minify -o yaml --raw | base64` to export.  
Put this into a secret named KUBE_CONFIG in GitHub.  

[1]: https://github.com/jetersen/ghaction.file.sync/
[2]: .github/syncs.yml
