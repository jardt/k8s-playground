# k8s playground

playground using lima k3s vm

## setup

Create lima vm with `limactl create`
use k3s template but edit it to give it more ram and cpu.
Also edit k3s command in template
with:

```
        --disable=traefik,metrics-server,servicelb
        --write-kubeconfig-mode 0644
        --flannel-backend=none
        --disable-network-policy
        --disable-kube-proxy
```

We will install cilium these things is not necessary. And some things will be installed "manually" after bootstrapping.

## bootstrap

[Flux operator needs a private key secret for github app](https://fluxcd.io/blog/2025/04/flux-operator-github-app-bootstrap/#github-app-docs)

App id can be found on the app page. To get install id install the app for the repo, then get the install id from the url:
`https://github.com/settings/installations/{id}`

When this key is in cluster bootstap task can be ran:
run `task bootstrap:main` to set up crd`s, cilium, and flux.
