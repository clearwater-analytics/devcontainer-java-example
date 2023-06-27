#!/bin/bash

# Function to handle redeployment for a specific module
redeploy_module() {
  local module_folder=$1
  local war_file=$(find "$module_folder" -maxdepth 1 -name "*.war" -type f -print -quit)
  if [ -n "$war_file" ]; then
    local war_file_name=$(basename "$war_file")
    local webapps_folder="${CATALINA_HOME}/webapps"

    # Copy the .war file from the module's target folder to the webapps directory
    cp "$war_file" "$webapps_folder/"

  fi
}

# Function to handle redeployment for all modules
redeploy_all_modules() {
  # Stop Tomcat
  catalina.sh stop
  # Remove any existing .war files for the module in the webapps directory
  rm -f "${CATALINA_HOME}/webapps/"*.war
  local modules_folder="/workspace"

  for module_folder in "$modules_folder"/*; do
    if [ -d "$module_folder" ]; then
      redeploy_module "$module_folder/target"
    fi
  done
  # Start Tomcat
  catalina.sh run
}

# Get the path of the catalina_opts.txt file
CATALINA_OPTS_FILE="${CATALINA_HOME}/catalina_opts.txt"

# Check if the catalina_opts.txt file exists
if [ -f "$CATALINA_OPTS_FILE" ]; then
  # Read the contents of the file and concatenate them into a space-separated format
  CATALINA_OPTS=$(cat "$CATALINA_OPTS_FILE" | tr '\n' ' ')
else
  echo "Unable to find or read the catalina_opts.txt file at ${CATALINA_OPTS_FILE}. Using default CATALINA_OPTS value."
  CATALINA_OPTS=""
fi

# Export the CATALINA_OPTS variable
export CATALINA_OPTS

# Initial deployment for all modules
redeploy_all_modules
