# Shop Helm Umbrella Chart

## Blue/Green Deployment test:

cd chart-blue-green

oc new-project test

helm upgrade --install  shop-release . -n test --debug --values no-istio/values-no-istio.yaml

http://products-umbrella-online-test.apps-crc.testing/products
http://products-umbrella-offline-test.apps-crc.testing/products

helm upgrade --install  shop-release . -n test --debug --values no-istio/values-no-istio.yaml --set products-green.image.tag=v2 --set discount-green.image.tag=v2

helm delete  shop-release -n test
