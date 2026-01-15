#!/bin/bash
# Git pre-commit hook to automatically update commit info
# Install this by running: cp pre-commit-hook.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

set -e  # Exit on any error

# Get the repository root directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# Run the update script from the repository root
cd "$REPO_ROOT"

if [ ! -f "update-commit-info.sh" ]; then
  echo "Error: update-commit-info.sh not found in repository root"
  exit 1
fi

# Run the update script
if ! ./update-commit-info.sh; then
  echo "Error: Failed to update commit info"
  exit 1
fi

# Add the updated file to the commit
git add boards/shields/nice_view_disp/widgets/commit_info.h

echo "✓ Updated commit info for this commit"
