#!/bin/bash

set -e

docker compose up -d

# Wait a few seconds for the containers to initialize correctly
sleep 5


# Get the API Key from the `spotify-auth-proxy` container and write the API Key to `terraform.tfvars`
CONTAINER_NAME="spotify-auth-proxy"
API_KEY=$(docker logs "$CONTAINER_NAME" 2>&1 | grep "APIKey:" | tail -n1 | awk '{print $2}')

if [[ -z "$API_KEY" ]]; then
    echo "Error: Could not retrieve the API Key from Spotify Auth Proxy"
    exit 1
fi

echo "spotify_api_key = \"$API_KEY\"" > "$(dirname "$0")/terraform/terraform.tfvars"

# Get the authentication URL from the container logs
AUTH_URL=$(docker logs "$CONTAINER_NAME" 2>&1 | grep "Auth URL:" | tail -n1 | awk '{print $3}')

if [[ -z "$AUTH_URL" ]]; then
    echo "Error: Could not retrieve the authentication URL from the logs"
    exit 1
fi

# Open the URL in the browser automatically
if command -v xdg-open &>/dev/null; then
    xdg-open "$AUTH_URL"  # Linux
elif command -v open &>/dev/null; then
    open "$AUTH_URL"  # macOS
elif command -v start &>/dev/null; then
    start "$AUTH_URL"  # Windows
else
    echo "Could not open automatically, please copy and paste this URL into your browser:"
    echo "$AUTH_URL"
fi


echo "Everything is working."
