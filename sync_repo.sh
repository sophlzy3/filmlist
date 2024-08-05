#!/bin/bash

# Navigate to the repository directory
cd /Users/sophie/Downloads/github-list-project || exit

# Add any new or modified files
git add .

# Check for any changes to commit
if ! git diff-index --quiet HEAD --; then
  # Commit changes with a timestamp
  git commit -m "Commit at $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Push committed changes
git push origin main

# =============================
# Stash any remaining changes
git stash -u

# Pull changes from the remote repository
git pull origin main --rebase

# Check for any merge conflicts or errors
if [ $? -ne 0 ]; then
  echo "Error during git pull"
  exit 1
fi

# Apply the stashed changes
git stash pop

# =============================
# Push changes to the remote repository
echo "Pushing changes to remote..."
git push origin main

# Check for any errors during push
if [ $? -ne 0 ]; then
  echo "Error during git push"
  exit 1
fi

echo "Sync completed."
