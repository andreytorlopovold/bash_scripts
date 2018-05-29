#!/bin/sh

IS_INSIDE_REPO=$(git rev-parse --is-inside-work-tree 2>/dev/null)
if [[ $IS_INSIDE_REPO == "false" ]]; then
    exit 1
fi;

NAME=$(git branch | awk '/\*/ { print $2; }')
REMOTE_EXIST=$(git ls-remote --heads 2>/dev/null|awk -F 'refs/heads/' '{print $2}'|grep -x $NAME|wc -l)
if [ $REMOTE_EXIST -eq 1 ]; then
  COMMIT_COUNT=$(git log origin/$NAME..$NAME --oneline | wc -l)
  if [ $COMMIT_COUNT -gt 5 ]; 
  then
   git push
  fi
else 
 echo "NO REMOTE BRANCH"
fi