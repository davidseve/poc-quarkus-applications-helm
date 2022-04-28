# Shop Helm Umbrella Chart

## Blue/Green Deployment test:

cd chart-blue-green

oc new-project test

helm upgrade --install  shop-release . -n test --debug --values no-istio/values-no-istio.yaml

http://products-umbrella-online-test.apps-crc.testing/products
http://products-umbrella-offline-test.apps-crc.testing/products

helm upgrade --install  shop-release . -n test --debug --values no-istio/values-no-istio.yaml --set products-green.image.tag=v2 --set discount-green.image.tag=v2

helm delete  shop-release -n test

## Blue/Green Deployment GitOps:

Create branch: blue-green

cd gitops

oc apply -f application-blue-green.yaml -n openshift-gitops

Test:
http://products-umbrella-online-quarkus-gitops.apps-crc.testing/products
http://products-umbrella-offline-quarkus-gitops.apps-crc.testing/products


## Blue/Green Deployment Tekton:

cd pipelines

oc apply -f continuos-deployment/pipeline.yaml -n poc-pipelines
export FOLDER=blue-green

### Step1 Upgrade Products Offline for testing
oc create -f continuos-deployment/$FOLDER/pipelinerun-products-v2.yaml -n poc-pipelines

### Step2 Change configuration Products Offline (new version)
oc create -f continuos-deployment/$FOLDER/pipelinerun-products-v2-configuration.yaml -n poc-pipelines

### Step3 Scale up Products Offline (new version)
oc create -f continuos-deployment/$FOLDER/pipelinerun-products-v2-scale-up.yaml -n poc-pipelines

### Step4 Switch Products new version to Online
oc create -f continuos-deployment/$FOLDER/pipelinerun-products-v2-switch.yaml -n poc-pipelines

### Step5 Products old version Scale down, align version and switch to OffLine
oc create -f continuos-deployment/$FOLDER/pipelinerun-products-v2-scale-down.yaml -n poc-pipelines
