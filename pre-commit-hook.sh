#!/bin/bash
# Git pre-commit hook to automatically update commit info
# Install this by running: cp pre-commit-hook.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

# Run the update script
./update-commit-info.sh

# Add the updated file to the commit
git add boards/shields/nice_view_disp/widgets/commit_info.h

echo "Updated commit info for this commit"
