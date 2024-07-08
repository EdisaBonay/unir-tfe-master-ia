#!/bin/bash

# Nombre del contenedor
CONTAINER_NAME="pycaret-api-container"

# Detener y eliminar los servicios actuales si existen
echo "Stopping and removing existing containers..."
docker-compose down

# Construir y levantar los servicios con docker-compose
echo "Building and starting new containers..."
docker-compose up --build -d

# Mostrar logs en tiempo real
echo "Showing logs..."
docker-compose logs -f