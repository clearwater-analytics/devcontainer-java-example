FROM mcr.microsoft.com/devcontainers/java:17-jdk-bookworm

################### Docker-from-Docker installation ###################

# Install required packages
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Import the Docker repository GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set permissions on GPG key
RUN chmod a+r /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository to the APT sources
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists and install Docker
RUN apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# https://github.com/microsoft/vscode-dev-containers/tree/main/containers/docker-from-docker
ARG NONROOT_USER=vscode

RUN echo -e "#!/bin/sh\n\
    sudoIf() { if [ \"\$(id -u)\" -ne 0 ]; then sudo \"\$@\"; else \"\$@\"; fi }\n\
    SOCKET_GID=\$(stat -c '%g' /var/run/docker.sock) \n\
    if [ \"${SOCKET_GID}\" != '0' ]; then\n\
        if [ \"\$(cat /etc/group | grep :\${SOCKET_GID}:)\" = '' ]; then sudoIf groupadd --gid \${SOCKET_GID} docker-host; fi \n\
        if [ \"\$(id ${NONROOT_USER} | grep -E \"groups=.*(=|,)\${SOCKET_GID}\(\")\" = '' ]; then sudoIf usermod -aG \${SOCKET_GID} ${NONROOT_USER}; fi\n\
    fi\n\
    exec \"\$@\"" > /usr/local/share/docker-init.sh \
    && chmod +x /usr/local/share/docker-init.sh

############## End Docker-from-Docker section #############

################### Tomcat installation ###################

# Set Tomcat version and download URL
ENV TOMCAT_VERSION=10.1.10
ENV TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

# Download and extract Tomcat
RUN wget -qO- "${TOMCAT_URL}" | tar xvz -C /usr/local

# Set CATALINA_HOME variable
ENV CATALINA_HOME=/usr/local/apache-tomcat-$TOMCAT_VERSION

# Copy tomcat-users.xml file into tomcat config folder
COPY tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml

# Add Tomcat bin directory to PATH
ENV PATH="${CATALINA_HOME}/bin:${PATH}"

# Pass CATALINA_OPTS_FILE as a build argument and copy the file to CATALINA_HOME
ARG CATALINA_OPTS_FILE
COPY ${CATALINA_OPTS_FILE} ${CATALINA_HOME}/catalina_opts.txt

# Set tomcat folder permissions
RUN chown -R vscode:vscode $CATALINA_HOME

# Copy the deployment script to the container and make an alias for it
COPY deploy.sh /usr/local/bin/deploy.sh
RUN echo "alias deploy='/usr/local/bin/deploy.sh'" >> /home/vscode/.bashrc

# Make the deployment script executable
RUN chmod +x /usr/local/bin/deploy.sh

# Expose Tomcat port
EXPOSE 8080

################### End Tomcat section ###################

################### Maven configuration ##################

# Establish .m2 folder, set ownership, and copy settings.xml file to the container
RUN mkdir -p /usr/local/.m2/repository 
RUN chown -R vscode:vscode /usr/local/.m2
COPY mvnsettings.xml /usr/local/.m2/mvnsettings.xml

################### End Maven section ####################

######### More Docker-from-Docker recommendations ########

# https://github.com/microsoft/vscode-dev-containers/tree/main/containers/docker-from-docker
# VS Code overrides ENTRYPOINT and CMD when executing `docker run` by default.
# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

######### End Docker-from-Docker recommendations #########