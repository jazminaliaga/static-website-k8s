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
				└── deploy.sh
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

## 🚀 Instrucciones para levantar el entorno manual

### 1. Clonar los repositorios 📥
Crear una carpeta llamada `devops-cloud-project`, una vez dentro abrir un bash git y clonar los siguientes repositorios: 
```
git clone https://github.com/jazminaliaga/static-website.git web-content
git clone https://github.com/jazminaliaga/static-website-k8s.git
```
### 2. Iniciar Minikube y montar volumen local 🚜
Parado en la carpeta `static-website`, abrir una terminal y ejecutar el siguinte comando:
	
|💡*Reemplazá `PATH_A_TU_PROYECTO` por la ruta completa a tu carpeta `devops-cloud-project`.*

```
minikube start --mount --mount-string="PATH_A_TU_PROYECTO\devops-cloud-project\static-website:/mnt/web-content"

cd ..
```
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
---------------------------------------------------------------------------------------------------
## ⚙️ Automatización del despliegue (opcional)

Este repositorio incluye un script llamado `deploy.sh` que permite **automatizar todo el proceso anterior** de manera sencilla y reproducible.

### ¿Qué hace el script?

- Verifica que tengas instalados: Docker, Minikube, Kubectl y Git.
- Crea una carpeta base en tu `$HOME` (`devops-cloud-project`).
- Clona automáticamente los repositorios necesarios (`static-website` y `static-website-k8s`).
- Inicia Minikube con un volumen montado.
- Aplica todos los manifiestos de Kubernetes (PV, PVC, Deployment, Service).
- Verifica el estado del entorno.
- Abre el sitio en tu navegador.

### ▶️ ¿Cómo se usa?

1. Descargá el archivo `deploy.sh` desde este repositorio.

2. Abrí una terminal (Bash, Git Bash o WSL) y hacelo ejecutable:
```
chmod +x deploy.sh
```
3. Ejecutalo:
```
./deploy.sh
```
💡 *El script creará todo automáticamente. No necesitás clonar los repos a mano. Asegurate de ejecutarlo desde un entorno compatible con Bash.*

