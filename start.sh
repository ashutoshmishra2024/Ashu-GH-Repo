#!/bin/bash

# GitHub repository and token
REPO_URL="https://github.com/your-username/your-repo"
RUNNER_TOKEN="your_runner_token"

# Configure the runner
./config.sh --url $REPO_URL --token $RUNNER_TOKEN --unattended --replace

# Run the runner
./run.sh


