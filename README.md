# DevContainer Usage

This repository contains a [DevContainer](https://containers.dev) setup which provides an isolated development environment with the necessary tools and configurations to develop, build, and deploy Quarkus web applications. It utilizes Docker to provide a consistent and reproducible development environment.

## Usage Instructions

### Prerequisites

In order to leverage this DevContainer, the following prerequisites are needed:
* Install [Docker Desktop](https://www.docker.com/)
* Install [Visual Studio Code](https://code.visualstudio.com/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
* Install Git and clone this repository
    * If you're on Windows, we recommend you do this within WSL2 for disk-I/O performance reasons. Install the [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) VSCode extension too.

### Start-up instructions

To boot up this DevContainer, simply run the `Reopen in Container` action. You can do this in three different places
* There may be an automatic popup in the bottom-right prompting you with a button
* The `><` button in the bottom-left corner + menu-option in the top-center
* Search for it in the command palette

Separate configurations are provided to simulate different environments you would like to target for this project's dependencies. Choose which you'd like to use, and the appropriate DevContainer will launch.

### Build and Deploy instructions
Maven and Quarkus are already installed in the DevContainer. You can leverage traditional command-line CLIs to run them.

**tl,dr**: `./mvnw compile quarkus:dev` will build and run your application.

Access your deployed application by navigating to http://localhost:8080/ in your web browser. You can also observe the environment-specific variables feature by loading up http://localhost:8080/hello.

## Under-the-Hood Details

A few different files are needed to make this DevContainer function. Here's the rundown of them all and what purposes they serve.

The flow starts with the `devcontainer.json` file located in each environment-specific folder. 
* The presence of multiple `devcontainer.json` files is what triggers Visual Studio Code to present you with different environment options when reopening the folder in a container.
* The file configures many things: 
    * the `Dockerfile` to use to build the DevContainer
    * any Docker volume mounts
    * optional Dev Container features to install in the container
    * Visual Studio Code extensions and settings to install and set within the container

The `Dockerfile` handles all the setup logic to build the container. It installs and configures the following
* Java
* Docker-from-Docker
* Maven

Feel free to customize or tweak these files according to your specific needs.