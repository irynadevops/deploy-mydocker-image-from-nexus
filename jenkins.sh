#! /bin/bash
name=`kubectl get pods -A| grep docker | awk -F' ' '{print $2}'`
a=`kubectl get pod $name -o json | jq '.status.containerStatuses[] | { "image": .image, "imageID": .imageID }'`

export BUILD_NUMBER=$1
kubectl apply -f docker-deploy.yaml
if [ $(curl -s -o /dev/null -I -w "%{http_code}"  http://helloworld-izaitsava.k8s.izaitsava.playpit.by/helloworld-ws/) -ne 200 ]; then
  kubectl rollout undo deployment/$name
fi

#kubectl scale --replicas=0 deployment application
#kubectl scale --replicas=1 deployment application

#kubectl set image deployment/application app-container=$IMAGE

replica_spec=$(kubectl get deployment/$name -o jsonpath='{.spec.replicas}')
kubectl scale --replicas=0 deployment $name
kubectl scale --replicas=$replica_spec deployment $name


b=`kubectl get pod $name -o json | jq '.status.containerStatuses[] | { "image": .image, "imageID": .imageID }'`
