# DevContainer Usage

This folder contains a [DevContainer](https://containers.dev) setup which provides an isolated development environment with the necessary tools and configurations to develop, build, and deploy Java web applications. It utilizes Docker to provide a consistent and reproducible development environment.

## Usage Instructions

### Prerequisites

In order to leverage this DevContainer, the following prerequisites are needed:
* Install [Docker Desktop](https://www.docker.com/)
* Install [Visual Studio Code](https://code.visualstudio.com/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
* Install Git and clone this repository
    * If you're on Windows, we recommend you do this within WSL2 for disk-I/O performance reasons. Install the [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension too.

### Start-up instructions

To boot up this DevContainer, simply run the `Reopen in Container` action. You can do this in three different places
* Search for it in the command palette
* There may be an automatic popup in the bottom-right prompting you with a button
* The `><` button in the bottom-left corner + menu-option in the top-center

Separate configurations are provided for each environment you would like to target for this project's dependencies. Choose which you'd like to use, and the appropriate DevContainer will launch.

### Build and Deploy instructions
Apache Tomcat and Maven are already installed in the DevContainer. You can leverage traditional command-line CLIs to run them. If you do this manually, be sure to check the Dockerfile for the location of important config files.

The following additional run utilities have been built into this DevContainer:
* For Maven, the Visual Studio Code "Maven for Java" extension is automatically installed in the DevContainer.
    * Look for the "Maven" section in the left-sidebar. 
    * Right-click on your project, click `Run Maven Commands...` > `Favorites...` to run some common commands.
* For Tomcat, use the provided `deploy.sh` script to deploy your application locally on port 8080. 
    * No need to specify any .war files--the script deploys all .war files it can find within your source code tree
    * Open a terminal within Visual Studio Code and run the following command (alias):
    ```shell
    deploy
    ```

Access your deployed application by navigating to http://localhost:8080/ in your web browser. Check the `.devcontainer/tomcat-users.xml` file for the credentials needed to access the Tomcat manager GUI.

## Under-the-Hood Details

A few different files are needed to make this DevContainer function. Here's the rundown of them all and what purposes they serve.

The flow starts with the `devcontainer.json` file located in each environment-specific folder. 
* The presence of multiple `devcontainer.json` files is what triggers Visual Studio Code to present you with different environment options when reopening the folder in a container.
* The file configures many things: 
    * the `Dockerfile` to use to build the DevContainer
    * any Docker volume mounts
    * the location of its associated `catalina_opts.txt` file
    * Visual Studio Code extensions and settings to install and set within the container

The `Dockerfile` handles all the setup logic to build the container. It installs and configures the following
* Java
* Docker-from-Docker
* Tomcat
* Maven
* Copying the provided `catalina_opts.txt`, `mvnsettings.xml`, `tomcat-users.xml`, and `deploy.sh` files into the container

The `deploy.sh` file is a custom-built script that hunts for all .war files within target folders in your source tree, copies them to Tomcat's webapps folder, and starts Tomcat. It also contains special logic to transform the newline-separated list of properties in the `catalina_opts.txt` file into a single-line property string which is stored in the `CATALINA_OPTS` environment variable.

Feel free to customize or tweak these files according to the team's specific needs.