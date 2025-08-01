# k8s playground

Playground using k3s in lima vm.

## Setup

Create lima vm with `limactl create`
use k3s template but edit it to give it more ram and cpu.
Also edit k3s command in template
with:

```
        --disable=traefik,metrics-server,servicelb,coredns
        --write-kubeconfig-mode 0644
        --flannel-backend=none
        --disable-network-policy
        --disable-kube-proxy
```

We will install cilium these things is not necessary. And some things will be installed "manually" after bootstrapping.

## Bootstraping

[Flux operator needs a private key secret for github app](https://fluxcd.io/blog/2025/04/flux-operator-github-app-bootstrap/#github-app-docs) to access repo.
App id can be found on the app page. To get install id install the app for the repo, then get the install id from the url:
`https://github.com/settings/installations/{id}`

When this key is in cluster bootstrap task can be ran:
run `task bootstrap:main` to set up crd`s, cilium, and flux.
