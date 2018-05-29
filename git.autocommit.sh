#!/bin/sh

IS_INSIDE_REPO=$(git rev-parse --is-inside-work-tree 2>/dev/null)
if [[ $IS_INSIDE_REPO == "false" ]]; then
    exit 1
fi;

function git_change_count {
  a=0
  { git diff --cached --numstat; git diff --numstat; } | awk '{ a+=($1+$2) } END {print a}'
}

CHANGE_LINES=$(git_change_count)
if [[ $CHANGE_LINES == "" ]]; then 
  CHANGE_LINES=0
fi

CHECK_NUMBER=300
if [ $CHANGE_LINES -gt $CHECK_NUMBER ]; 
then
  touch ct.md
  TASK_NAME=$(cat ct.md) 
  git add .
  git ci -am "$TASK_NAME: autoupdate changes: $CHANGE_LINES lines "
fi

NAME=$(git branch | awk '/\*/ { print $2; }')
REMOTE_EXIST=$(git ls-remote --heads 2>/dev/null|awk -F 'refs/heads/' '{print $2}'|grep -x $NAME|wc -l)
if [ $REMOTE_EXIST -eq 1 ]; then
  COMMIT_COUNT=$(git log origin/$NAME..$NAME --oneline | wc -l)
  if [ $COMMIT_COUNT -gt 15 ]; 
  then
   git push
  fi
else 
 echo "NO REMOTE BRANCH"
fi