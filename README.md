# k8s playground

Playground using k3s in lima vm.

## Setup

Create vm with template in repo:
`cat k3s-teplate.yaml | limactl create --name=playground -`

or manually

Create lima vm with `limactl create`
use k3s template but edit the template to change k3s setup with:

```
        --disable=traefik,metrics-server,servicelb,coredns
        --write-kubeconfig-mode 0644
        --flannel-backend=none
        --disable-network-policy
        --disable-kube-proxy
```

We will install cilium these things is not necessary. And some things will be installed "manually" after bootstrapping.

Good idea to give the vm some more juice: `limactl edit --cpus 4 --memory 8`

Start it: `limactl start playground`

## Bootstraping

Get kubconfig:
`export KUBECONFIG="~/.lima/playground/copied-from-guest/kubeconfig.yaml"`

[Flux operator needs a private key secret for github app](https://fluxcd.io/blog/2025/04/flux-operator-github-app-bootstrap/#github-app-docs) to access repo.
App id can be found on the app page. To get install id install the app for the repo, then get the install id from the url:
`https://github.com/settings/installations/{id}`

To create secret for flux we need the namepace first:
`k apply -f k8s/apps/flux-system/namespace.yaml`

Add secret:
`flux create secret githubapp flux-system \
  --app-id=<ID> \
  --app-installation-id=<INSTALL_ID> \
  --app-private-key=./private.key.pem`

When this secret is in cluster bootstrap task can be ran:
run `task bootstrap:main` to set up crd`s, cilium, and flux.

Cluster shuold now be up and running with:

- cilium
- flux operator
- coredns
- metrics server

and the whoami pod shuold be there meaning flux has reconciled with git repo. 🥳

## TODO
