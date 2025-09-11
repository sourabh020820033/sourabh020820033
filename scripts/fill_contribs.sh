#!/usr/bin/env bash
set -euo pipefail


# number of days back to fill (365 for full year)
DAYS=365


# file to change repeatedly
FILE=contrib-streak.md


# Make sure file exists
if [ ! -f "$FILE" ]; then
echo "# Contribution filler" > "$FILE"
git add "$FILE"
git commit -m "chore: create $FILE for contribution filler" || true
fi


for i in $(seq 0 $((DAYS-1))); do
# compute date in UTC for i days ago
DATE=$(date -u -d "-$i day" +"%Y-%m-%dT12:00:00Z")


# modify file to ensure content changes each commit
echo "Commit for $DATE" >> "$FILE"


# set author/committer date so GitHub counts the contribution on that day
export GIT_AUTHOR_DATE="$DATE"
export GIT_COMMITTER_DATE="$DATE"


# create a commit
git add "$FILE"
git commit -m "chore: contribution for $DATE" --no-verify || true


done


# unset the envs
unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE


echo "Done generating $DAYS commits. Push the branch to update GitHub contributions."
