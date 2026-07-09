#!/bin/bash

# Exit immediately if any command fails
set -e

BRANCH=$1

PROJECT_DIR="/home/master/project/full-stack-project"
CLIENT_DIR="$PROJECT_DIR/src/client"
SERVER_DIR="$PROJECT_DIR/src/server"
NGINX_DIR="/var/www/fullstack"

echo "========================================"
echo "Starting Deployment"
echo "Branch : $BRANCH"
echo "========================================"

# Go to project
cd "$PROJECT_DIR"

echo "Fetching latest code..."
git fetch origin

echo "Checking out branch..."
git checkout "$BRANCH"

echo "Pulling latest changes..."
git pull origin "$BRANCH"

##############################################
# Frontend
##############################################

echo "Installing frontend dependencies..."

cd "$CLIENT_DIR"

npm install

echo "Building React application..."

npm run build

echo "Updating Nginx web root..."

sudo rm -rf ${NGINX_DIR:?}/*

sudo cp -r build/* "$NGINX_DIR"

##############################################
# Backend
##############################################

echo "Installing backend dependencies..."

cd "$SERVER_DIR"

npm install

echo "Restarting backend..."

pm2 restart fullstack-backend

##############################################
# Reload Nginx
##############################################

echo "Reloading Nginx..."

sudo systemctl reload nginx

echo "========================================"
echo "Deployment Completed Successfully"
echo "========================================"