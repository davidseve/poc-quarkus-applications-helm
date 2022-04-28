
#!/bin/bash

oc policy add-role-to-user \
  edit \
  system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller \
  --rolebinding-name=argocd-edit \
  -n quarkus-gitops
oc apply -f ./role.yaml
oc policy add-role-to-user \
  argocd-edit-role \
  system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller \
  --rolebinding-name=new-argocd-edit-role \
  --role-namespace=quarkus-gitops \
  -n quarkus-gitops
