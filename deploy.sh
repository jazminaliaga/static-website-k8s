#!/bin/bash

# 🚀 Script automático para desplegar el sitio estático en Minikube

set -e  # Salir ante cualquier error

# 0. Comprobar SO
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  echo "⚠️ Este script está pensado para Bash. En Windows, usá WSL o Git Bash."
  exit 1
fi

# 1. Comprobar que tiene Docker, Minikubem kubectl y Git instalados
for cmd in git minikube kubectl; do
  if ! command -v $cmd &> /dev/null; then
    echo "❌ Error: '$cmd' no está instalado. Por favor, instalalo antes de continuar."
    exit 1
  fi
done

# 2. Definir ruta base del proyecto
BASE_DIR="$HOME/devops-cloud-project"
REPO_WEB="https://github.com/jazminaliaga/static-website.git"
REPO_K8S="https://github.com/jazminaliaga/static-website-k8s.git"
MOUNT_PATH="/mnt/web-content"

echo "📁 Creando estructura de carpetas..."
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# 3. Verificar que los repositorios no estén clonados y clonarlos
echo "📥 Clonando repositorios..."
if [ ! -d "$BASE_DIR/web-content" ]; then
  git clone "$REPO_WEB" web-content
else
  echo "📂 Repositorio web ya clonado, omitiendo..."
fi

if [ ! -d "$BASE_DIR/static-website-k8s" ]; then
  git clone "$REPO_K8S" static-website-k8s
else
  echo "📂 Repositorio K8s ya clonado, omitiendo..."
fi

# 4. Iniciar Minikube con volumen montado
echo "🚜 Iniciando Minikube..."
minikube start -p static-site --mount --mount-string="$BASE_DIR/web-content:/mnt/web-content"

# 5. Verificar que el contexto esté listo antes de usar kubectl
if kubectl config get-contexts | grep -q "static-site"; then
  kubectl config use-context static-site
fi

echo "⏳ Esperando que el API server esté disponible..."
until kubectl get nodes &>/dev/null; do
  sleep 2
done

# 6. Limpieza de errores previos (si existen)
kubectl delete deployment static-site --ignore-not-found
kubectl delete service static-site-service --ignore-not-found
kubectl delete pvc static-site-pvc --ignore-not-found
kubectl delete pv static-site-pv --ignore-not-found

# 7. Aplicar manifiestos de Kubernetes
echo "📦 Creando PersistentVolume..."
kubectl apply -f "$BASE_DIR/static-website-k8s/volumes/persistent-volume.yaml"

echo "📦 Creando PersistentVolumeClaim..."
kubectl apply -f "$BASE_DIR/static-website-k8s/volumes/persistent-volume-claim.yaml"

echo "🛠️ Creando Deployment..."
kubectl apply -f "$BASE_DIR/static-website-k8s/deployments/deployment.yaml"

echo "🌐 Creando Service..."
kubectl apply -f "$BASE_DIR/static-website-k8s/services/service.yaml"

# 8. Verificaciones básicas
echo "🔍 Esperando que los pods estén activos..."
kubectl wait --for=condition=ready pod -l app=static-site --timeout=60s

echo "✅ Estado de los pods:"
kubectl get pods

echo "✅ Estado de PV y PVC:"
kubectl get pv,pvc

# 9. Mostrar archivos montados dentro del pod
echo "🧪 Verificando archivos montados..."
kubectl exec -it "$(kubectl get pod -l app=static-site -o jsonpath="{.items[0].metadata.name}")" -- ls /usr/share/nginx/html

# 10. Abrir el sitio web
echo "🌍 Accediendo al sitio desplegado..."
minikube service static-site-service -p static-site
