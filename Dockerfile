# Author -- meevs
# Creation Date -- 2023-03-09
# File Name -- Dockerfile
# Notes --

# Forge server builder
FROM alpine:latest AS forge_builder

ARG JAVA_VERSION="17"
ARG MC_VERSION="1.19.3"
ARG FORGE_VERSION="44.1.23"
ARG INSTALL_DIR="/forge_server/"

ENV JAVA_VERSION="${JAVA_VERSION}"
ENV MC_VERSION="${MC_VERSION}"

# Setup build environment
RUN apk add --no-cache curl openjdk${JAVA_VERSION}\
 && mkdir --parent ${INSTALL_DIR}

WORKDIR "${INSTALL_DIR}"

RUN mkdir --parent "/tmp/forge"

# Download/install server
RUN curl --location "https://maven.minecraftforge.net/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar" --output "/tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar"\
	&& java -jar "/tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar" --installServer\
	&& tar --create --gzip --file "/tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}.tar.gz" --directory "${INSTALL_DIR}" ./

# Forge server runtime
FROM alpine AS forge_mc

ARG JAVA_VERSION="17"
ARG MC_VERSION="1.19.3"
ARG FORGE_VERSION="44.1.23"
ARG INSTALL_DIR="/forge_server"

ENV JAVA_VERSION="${JAVA_VERSION}"
ENV MC_VERSION="${MC_VERSION}"
ENV FORGE_VERSION="${FORGE_VERSION}"
ENV MC_EULA="false"
ENV MIN_RAM="1G"
ENV MAX_RAM="4G"

RUN apk add --no-cache "openjdk${JAVA_VERSION}-jre" bash 

#RUN mkdir --parent /tmp/forge/

COPY --from=forge_builder "/tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}.tar.gz" /tmp/forge/

# Setup server
RUN mkdir --parent ${INSTALL_DIR}\
 && tar --extract --gzip --file /tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}.tar.gz --directory /tmp/forge/\
 && rm /tmp/forge/forge-${MC_VERSION}-${FORGE_VERSION}.tar.gz

WORKDIR ${INSTALL_DIR}

COPY "./config_files/${SERVER_CONFIG}" "${INSTALL_DIR}/server.properties"

# Copy start script into build
COPY ./init_scripts/start_server.sh /tmp/forge/start_server.sh
COPY ./init_scripts/init_container.sh /usr/bin/init_container.sh

RUN chmod a+x "/usr/bin/init_container.sh"

CMD [ "/bin/sh", "-c" ]
ENTRYPOINT [ "init_container.sh" ]
