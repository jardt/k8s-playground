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

### Required env for installing

Having these env variables set is required for bootstrap task to succeed

Get kubconfig:
`export KUBECONFIG="~/.lima/playground/copied-from-guest/kubeconfig.yaml"`

create a age key to encrypt secrets with sops:
`age-keygen`

set env vars:

`export SOPS_AGE_KEY=<PRIVATE AGE KEY>`

edit the k8s/compontents/common/sops/secret.sops.yaml to contain the private key.
encrypt it with sops.

### Bootstrap task

run `task bootstrap:playground` to create vm, start it, set up crd`s, namespaces, age key secret, cilium, coredns, and flux.

Cluster should now be up and running with:

- cilium
- flux operator
- coredns
- metrics server

and the whoami pod should be there meaning flux has reconciled with git repo. 🥳

## Sops

Secrets files should have the name *.sops.yaml, as per the .sops.yaml config. ( set public key here )
While having set the SOPS_AGE_KEY env var, run `sops -e -i path/to/file/secret.sops.yaml` to encrypt it in place.

Cluster will have the private key to decrypt as the bootstraping will apply a secret containing it using the env var.
The cluster apps kustomization will use that to decrypt the secret with the same private key in k8s/compontents/common/sops/, and flux will create a secret for each namespace create a secret with the same private key.

# Destroying

`task bootstrap:destory` to delate the vm

## TODO
