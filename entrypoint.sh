#!/bin/bash
set -e

# If TABLEAU_PAT_JSON is provided, write it to the specified file
if [ -n "$TABLEAU_PAT_JSON" ]; then
    echo "Writing TABLEAU_PAT_JSON to ${TABLEAU_PAT_TOKEN_FILE:-/app/pat.json}..."
    echo "$TABLEAU_PAT_JSON" > "${TABLEAU_PAT_TOKEN_FILE:-/app/pat.json}"
fi

# Set default values for variables if not provided
TABLEAU_PAT_TOKEN_FILE=${TABLEAU_PAT_TOKEN_FILE:-/app/pat.json}

# Build the arguments list
ARGS=("-e")

if [ -n "$TABLEAU_CLIENT" ]; then
    ARGS+=("--client=$TABLEAU_CLIENT")
fi

if [ -n "$TABLEAU_SITE" ]; then
    ARGS+=("--site=$TABLEAU_SITE")
fi

if [ -n "$TABLEAU_USER_EMAIL" ]; then
    ARGS+=("--userEmail=$TABLEAU_USER_EMAIL")
fi

if [ -n "$TABLEAU_PAT_TOKEN_ID" ]; then
    ARGS+=("--patTokenId=$TABLEAU_PAT_TOKEN_ID")
fi

if [ -n "$TABLEAU_PAT_TOKEN_FILE" ]; then
    ARGS+=("--patTokenFile=$TABLEAU_PAT_TOKEN_FILE")
fi

if [ -n "$TABLEAU_POOL_ID" ]; then
    ARGS+=("--poolId=$TABLEAU_POOL_ID")
fi

echo "Starting Tableau Bridge with arguments: ${ARGS[@]}"

exec /opt/tableau/tableau_bridge/bin/run-bridge.sh "${ARGS[@]}"
