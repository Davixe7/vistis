#!/bin/bash

# Detener ejecución si hay algún error
set -e

# Directorio del proyecto
PROJECT_DIR="/home/smith/Proyectos/visits"
DEPLOY_DIR="/home/smith/Proyectos/visits/deploy"
SERVER_USER="root"
SERVER_HOST="phenlinea.com"
SERVER_DIR="/var/www/public_html/visitas.phenlinea.com"

# Construir el proyecto
echo "Ejecutando npm run build..."
cd "$PROJECT_DIR"
npm run build

# Preparar archivos para el deploy
echo "Moviéndonos al directorio de deploy..."
cp -r ./dist/spa/* $DEPLOY_DIR
git add .
git commit -m "Deploy automático: $(date +'%Y-%m-%d %H:%M:%S')"
git push origin master || { echo "Error en git push"; exit 1; }

# Conectar al servidor y actualizar el código
echo "Conectando al servidor..."
ssh -tt "$SERVER_USER@$SERVER_HOST" << EOF
    cd "$SERVER_DIR"
    git pull origin master
    echo "Deploy completado."
EOF

echo "Despliegue finalizado con éxito."
