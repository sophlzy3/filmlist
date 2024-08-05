#!/bin/bash

# Navigate to the repository directory
cd /Users/sophie/Downloads/github-list-project || exit

echo "Current directory: $(pwd)"
echo "Listing files:"
ls -l

# Pull changes from the remote repository
echo "Pulling changes from remote..."
git pull origin main --rebase

# Check for any merge conflicts or errors
if [ $? -ne 0 ]; then
  echo "Error during git pull"
  exit 1
fi

# Add any new or modified files
echo "Adding changes..."
git add .

# Commit changes if there are any
if git diff-index --quiet HEAD --; then
  echo "No changes to commit"
else
  echo "Committing changes..."
  git commit -m "Automated commit message"
fi

# Push changes to the remote repository
echo "Pushing changes to remote..."
git push origin main

# Check for any errors during push
if [ $? -ne 0 ]; then
  echo "Error during git push"
  exit 1
fi

echo "Sync completed."
