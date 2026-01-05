#!/bin/bash

echo ""
echo "Restoring frontend npm packages"
echo ""
cd frontend
npm install
if [ $? -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $?
fi

echo ""
echo "Building frontend"
echo ""
npm run build
if [ $? -ne 0 ]; then
    echo "Failed to build frontend"
    exit $?
fi

cd ..
. ./scripts/loadenv.sh

echo 'Creating Python virtual environment ".venv" in root'
python3 -m venv .venv

echo 'Installing dependencies from "requirements-dev.txt" into virtual environment'
./.venv/bin/python -m pip install -r requirements-dev.txt

echo ""
echo "Starting backend"
echo ""
./.venv/bin/python -m quart run --port=50505 --host=127.0.0.1 --reload
if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi
