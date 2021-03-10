# k8s auth + Tilt build, push and deploy GitHub composite action

GitHub composite action for k8s auth thereafter Tilt build, push and deploy.

This is still alpha and not ready for public use.
An example of this is that we work-around the problem that our Rancher is using external LB's with TLS termination. And Rancher itself uses self-signed certificates.

requires tilt, kubectl and docker. However you should probably have helm and rancher cli installed if you use them.

Usage

```yaml
    - uses: deltaprojects/action-tilt-auth-bpd@master
      with:
        # either rancher-*
        rancher-context: ${{ secrets.RANCHER_CONTEXT }} # Rancher context i.e. cluster-id:project-id
        rancher-token: ${{ secrets.RANCHER_TOKEN }} # Rancher API bearer token
        rancher-url: ${{ secrets.RANCHER_URL }} # Rancher API endpoint
        # or kube-config
        kube-config: ${{ secrets.KUBE_CONFIG }} # A base64 encoded kubectl config
        # if both are set, rancher-* is used.
```

Use either "kube-config" or "rancher-" inputs.

**kube-config**  
To create secret set your correct context in your local setup.  
Then run `kubectl config view --minify -o yaml --raw | base64` to export.  
Put this into a secret named KUBE_CONFIG in GitHub.  

**rancher-**  
To create a API key, login to Rancher Web UI and click your profile -> API & Keys.  
Create a new key with no scope. Put Bearer Token in GitHub secret RANCHER_TOKEN and Endpoint URL as RANCHER_URL.  
To select context run `rancher context switch` and copy the PROJECT ID into GitHub secret RANCHER_TOKEN.  
