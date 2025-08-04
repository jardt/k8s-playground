# k8s playground

Playground using k3s in lima vm.

## VM Setup manual

> [!NOTE]
> Not neccary if running task bootstrap:playground as it will create the vm
> If manually creating vm use bootstrap:deploy instead

Create vm with template in repo:
`cat k3s-template.yaml | limactl create --name=playground -`

or manually configure it

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

[Flux operator needs a private key secret for github app](https://fluxcd.io/blog/2025/04/flux-operator-github-app-bootstrap/#github-app-docs) to access repo.
App id can be found on the app page. To get install id, install the app in the repo, then get the install id from the url:
`https://github.com/settings/installations/{id}`

### Required env for installing

Having these env variables set is required for bootstrap task to succeed

Get kubconfig:
`export KUBECONFIG="~/.lima/playground/copied-from-guest/kubeconfig.yaml"`

create a age key to encrypt secrets with sops:
`age-keygen`

set env vars:

`export AGEKEY=<PRIVATE AGE KEY>`
`export APP_PRIVATE_KEY=<GITHUB APP PRIVE KEY .pem FILE CONTENT>`
`export APP_ID=<GITHUB APP ID>`
`export APP_INSTALLATION_ID=<INSTALL GITHUB APP ID>`

### Bootstrap task

run `task bootstrap:playground` to create vm, start it, set up crd`s, namespaces, age key secret, github app flux secret cilium, and flux.

Cluster should now be up and running with:

- cilium
- flux operator
- coredns
- metrics server

and the whoami pod should be there meaning flux has reconciled with git repo. 🥳

good idea to unset env variables: `unset AGEKEY`..

## Destroying

`task bootstrap:destory to delete vm`

## TODO
