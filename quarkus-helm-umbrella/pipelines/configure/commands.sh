#!/bin/bash

oc new-project poc-pipelines


export TOKEN=XXXXX

oc policy add-role-to-user    edit    system:serviceaccount:poc-pipelines:pipeline    --rolebinding-name=pipeline-edit    -n quarkus-gitops

oc create secret generic github-token    --from-literal=username=davidseve    --from-literal=password=${TOKEN}    --type "kubernetes.io/basic-auth"    -n poc-pipelines

oc annotate secret github-token "tekton.dev/git-0=https://github.com/davidseve"

oc secrets link pipeline github-token

tkn hub install task helm-upgrade-from-source
tkn hub install task kaniko
tkn hub install task git-cli -n poc-pipelines
