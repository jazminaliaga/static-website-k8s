# 🌐 DevOps Cloud Project: Static Website en Minikube

Este proyecto despliega una versión estática de un sitio web utilizando Minikube, Nginx, volúmenes persistentes y manifiestos de Kubernetes, todo versionado en Git.

---------------------------------------------------------------------------------------------------

## 🧱 Estructura del proyecto
```
devops-cloud-project/   ├── web-content/ 				# Contenido del sitio web
			│ 	└── index.html 
			│ 	└── style.css 
			│ 	└── assets/ 
			│ 		└── logo.png
			└── k8s-manifests/ 				# Manifiestos de Kubernetes 
				└── deployments/
					└── deployment.yaml
				└── services/					  
					└── service.yaml 
				└── volumes/ 
					├── persistent-volume.yaml 
					└── persistent-volume-claim.yaml
				└── README.md
```
---------------------------------------------------------------------------------------------------

## 🧰 Requisitos

- Docker
- Minikube
- Kubectl
- Git

|💡 Recomendado: Usar PowerShell con permisos de administrador.

---------------------------------------------------------------------------------------------------

## 🚀 Instrucciones para levantar el entorno

### 1. Clonar los repositorios 📥
Crear una carpeta llamada `devops-cloud-project`, una vez dentro abrir un bash git y clonar los siguientes repositorios: 
```
git clone https://github.com/jazminaliaga/static-website.git web-content
git clone https://github.com/jazminaliaga/devops-cloud-project.git
```
### 2. Iniciar Minikube y montar volumen local 🚜
Parado en la carpeta `static-website`, abrir una terminal y ejecutar el siguinte comando:
```
minikube start --mount --mount-string="PATH_A_TU_PROYECTO\devops-cloud-project\static-website:/mnt/web-content"

cd ..
```

|💡*Reemplazá `PATH_A_TU_PROYECTO` por la ruta completa a tu carpeta `devops-cloud-project`.*
### 3. Crear PersistentVolume 📦
```
kubectl apply -f PATH_A_TU_PROYECTO/devops-cloud-project/static-website-k8s/volumes/persistent-volume.yaml
```
### 4. Crear PersistentVolumeClaim 📦
```
kubectl apply -f PATH_A_TU_PROYECTO/devops-cloud-project/static-website-k8s/volumes/persistent-volume-claim.yaml
```
### 5. Crear Deployment 🛠️
```
kubectl apply -f PATH_A_TU_PROYECTO/devops-cloud-project/static-website-k8s/deployments/deployment.yaml
```
### 6. Crear Service 🌐
```
kubectl apply -f PATH_A_TU_PROYECTO/devops-cloud-project/static-website-k8s/services/service.yaml
```
### 7. Verificar estado de pods y volúmenes 🔍
✅ Verificar que el estado del pod sea *Running* 
```
kubectl get pods
```
✅ Verificar que el estado del pv y pvc sea *Bound*
```
kubectl get pv,pvc
```
### 8. Ingresar al pod y verificar archivos montados 🧪
```
kubectl exec -it $(kubectl get pod -l app=static-site -o jsonpath="{.items[0].metadata.name}") -- sh
ls /usr/share/nginx/html
```
Si ves el *index.html* entonces podes salir
```
exit
```
### 9. Acceder al sitio en el navegador 🌍
```
minikube service static-site-service
```
