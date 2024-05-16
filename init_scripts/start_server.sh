#! /bin/sh
# Author -- meevs
# Creation Date -- 2023-03-09
# File Name -- start_server.sh
# Notes --

# For versions [1.17 - ??]
if [ $(echo ${MC_VERSION} | awk -F '.' '{print $2}') -gt 16 ]; then
	echo "-Xms${MIN_RAM}" >> ./user_jvm_args.txt
	echo "-Xmx${MAX_RAM}" >> ./user_jvm_args.txt
	./run.sh
else # For Minecraft versions <= 1.16.0
	java -Xms${MIN_RAM} -Xmx${MAX_RAM} -jar ./forge-${MC_VERSION}-${FORGE_VERSION}.jar
fi
