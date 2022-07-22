# Kubernetes/Cloud Cheat Sheet

Useful reference: [link](https://kubernetes.io/docs/reference/kubectl/cheatsheet).

## Cluster

### Get Contexts

```bash
kubectl config get-contexts
```

### Get Current Context

```bash
kubectl config current-context
```

### Swap Context

```bash
kubectl config use-context my-cluster-name
```

### Get Namespaces

```bash
kubectl get namespaces
```

### Set Namespace

```bash
kubectl config set-context --current --namespace=namespaceboi
```

### Check Auth Status

```bash
kubectl auth can-i get pods
```

## Resource

### Delete Pod

```sh
kubectl delete pod podboi
```

### Get Secrets

Output using template:

```sh
kubectl get secrets/secret-name --template={{.data.host}} | base64 -d
```

Output using json (including escaping a character):

```sh
kubectl get secrets/secret-name -n {{namespace}} -o "jsonpath={.data.\.dockerconfigjson}"
```

### Get Network Policies

```sh
kubectl get netpol
```

### Get Environment Variables

```sh
kubectl exec podboi-7567cbcdc8-jk25f -c containerboi -- printenv
```

### Restart Deployment

```sh
kubectl rollout restart deployment/depboi
```

### Replica Sets

```sh
kubectl get rs
```

### Scale Replica Set

```sh
kubectl scale --replicas=3 replica-set-7546444b47
```

### Pod Yaml

```sh
kubectl get pods podboi-7567cbcdc8-jk25f -o yaml
```

### Get Logs

```sh
kubectl logs podboi-7567cbcdc8-jk25f -c containerboi
kubectl logs podboi-5957558857-zsfsx -c containerboi --previous
```

## Interactive

### Exec Into Pod

```sh
kubectl exec --stdin --tty podboi-7567cbcdc8-jk25f -c containerboi -- /bin/bash
```

