#Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install my-argo-cd argo/argo-cd --version 9.0.3 --namespace argocd --create-namespace


helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
helm install istiod istio/istiod --namespace istio-system 
helm install istio-base istio/base -n istio-system
helm install istio-ingress istio/gateway -n istio-system \
  --set name=istio-ingressgateway \
  --set service.type=NodePort
kubectl get svc -n istio-system istio-ingressgateway


helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets external-secrets/external-secrets --namespace external-secrets --create-namespace
helm install external-secrets external-secrets/external-secrets --namespace external-secrets 


helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace



# clone bookinfo sample app and deploy
git clone https://github.com/istio/istio.git
cd istio/samples/bookinfo/platform/kube

# deploy
kubectl create namespace mybookinfo
kubectl apply -f bookinfo.yaml -n mybookinfo


#Access the Bookinfo application
kubectl get pods -n mybookinfo
kubectl port-forward svc/productpage 9080:9080 -n mybookinfo
http://localhost:9080/productpage