#!/bin/bash

# Check if the version is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <version> [commit message]"
  exit 1
fi

if ! poetry --version; then
  echo "Error: Poetry is not installed. Are you in the right virtual environment?"
  exit 1
fi

# Set the version using poetry
if ! poetry version "$1"; then
  echo "Error: Failed to set version using poetry."
  exit 1
fi

git add pyproject.toml

# Use the provided commit message or default to "v<version>"
commit_message="v$(poetry version -s) ${2:-""}"

# Commit with the custom or default commit message
git commit -m "$commit_message"

# Tag the commit with the version
git tag "v$(poetry version -s)"

# Push the commit and the tag
git push
git push --tags

# Display the current version
poetry version
