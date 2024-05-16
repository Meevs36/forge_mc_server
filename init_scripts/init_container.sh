#! /bin/sh
# Author -- meevs
# Creation Date -- 2023-11-03
# File Name -- init_container.sh
# Notes --

# Perform container initialization
if [[ ! -f ./forge-${MC_VERSION}-${FORGE_VERSION}.jar ]]
then
	echo "Initializing container..."
	cp -rv /tmp/forge/* ./
fi

echo "Starting server..."
./start_server.sh
