# docker-ubuntu-doplhin-vnc
A sample example of a docker image which run a vnc server with dolphin emulator in background



gcloud beta container --project "gretrogames-209108" clusters create "dolphin-cluster" --zone "europe-west1-b" --username "admin" --cluster-version "1.9.7-gke.3" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --network "default" --subnetwork "default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard --no-enable-autoupgrade --enable-autorepair


 gcloud container clusters create dolphin-clusters

kubectl run doplhin --image p2lvoizin/doplhin-vnc:latest --env="VNC_PASSWORD=yourPW" --env="XFB_SCREEN=1280x800x24" --env="XFB_SCREEN_DPI=150" --port 5900
kubectl expose deployment doplhin --type LoadBalancer   --port 5900 --target-port 5900
kubectl get service doplhin



kubectl apply --prune -f pods.yaml --all --prune-whitelist=core/v1/ConfigMap
kubectl expose deployment doplhin-1 --type LoadBalancer   --port 5900 --target-port 5900
