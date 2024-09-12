#!/bin/bash

git remote set-url origin git@github.com:sophlzy3/list-project.git

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
echo "Pushing local commits..."
git push origin main

# =============================
# Stash any remaining changes
echo "Stashing any remaining changes..."
git stash -u

# Pull changes from the remote repository
echo "Pulling changes from remote repository..."
if ! git pull origin main --rebase; then
  echo "Error during git pull"
  # Apply stashed changes even if pull fails
  git stash pop
  exit 1
fi

# Apply the stashed changes
if git stash list | grep -q "stash@{0}"; then
  echo "Applying stashed changes..."
  git stash pop
  # Check if conflicts occurred during stash pop
  if [ $? -ne 0 ]; then
    echo "Conflicts occurred while applying stash. Please resolve them manually."
    exit 1
  fi
else
  echo "No stashed changes to apply."
fi

# Push again if needed after applying stash
echo "Pushing any additional changes after rebase..."
git push origin main

# Check for any errors during push
if [ $? -ne 0 ]; then
  echo "Error during git push"
  exit 1
fi

echo "Sync completed."
