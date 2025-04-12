# 🌐 DevOps Cloud Project: Static Website en Minikube

Este proyecto despliega una versión estática de un sitio web utilizando Minikube, Nginx, volúmenes persistentes y manifiestos de Kubernetes, todo versionado en Git.

---------------------------------------------------------------------------------------------------

## 🧱 Estructura del proyecto

devops-cloud-project/ ├── web-content/ # Contenido del sitio web
                      │ └── index.html 
                      │ └── style.css 
					  │ └── assets/ 
					  │ 	└── logo.png
					  ├── k8s-manifests/ # Manifiestos de Kubernetes 
					  │ └── deployments/
					  │ 	└── deployment.yaml
					  │ └── services/					  
					  │ 	└── service.yaml 
					  │ └── volumes/ 
					  │ 	├── persistent-volume.yaml 
					  │ 	└── persistent-volume-claim.yaml 
					  └── README.md

---------------------------------------------------------------------------------------------------

## 🧰 Requisitos

- Docker
- Minikube
- Kubectl
- Git

---------------------------------------------------------------------------------------------------

## 🚀 Instrucciones para levantar el entorno

### 1. Clonar los repositorios
git clone https://github.com/<jazminaliaga>/static-website.git web-content
git clone https://github.com/<jazminaliaga>/devops-cloud-project.git

### 2. Iniciar Minikube y montar volumen local
minikube start --mount --mount-string="$(pwd)/web-content:/mnt/web-content"

### 3. Crear PersistentVolume
kubectl apply -f devops-cloud-project/k8s-manifests/volumes/persistent-volume.yaml

### 4. Crear PersistentVolumeClaim
kubectl apply -f devops-cloud-project/k8s-manifests/volumes/persistent-volume-claim.yaml

### 5. Crear Deployment
kubectl apply -f devops-cloud-project/k8s-manifests/deployments/deployment.yaml

### 6. Crear Service
kubectl apply -f devops-cloud-project/k8s-manifests/services/service.yaml

### 7. Verificar estado de pods y volúmenes
kubectl get pods
kubectl get pv,pvc

### 8. Ingresar al pod y verificar archivos montados:
kubectl exec -it $(kubectl get pod -l app=static-site -o jsonpath="{.items[0].metadata.name}") -- sh
ls /usr/share/nginx/html

### 9. Acceder al sitio en el navegador
minikube service static-site-service

