#!/bin/bash

x=$1

echo
if [ "${x:${#x}-1}" == "/"  ]; then
  echo "This format is not allowed..."
  echo
  echo "  [/]     allowed format: /dir1/dir2"
  echo "  [X] Not allowed format: /dir1/dir2/"
  exit 2
fi

if ! [ -a $1 ]; then
  echo "Only path is allowed"
  exit 2
fi

if ! [ -z $2 ]; then
  echo "Only one parameter is allowed"
  exit 2
fi

for val in $*; do
  i=1
  echo "PARAM($i): $val"
  ((i++))
done

echo
for file in `ls $1`; do
  REPO="$1/$file"
  if [ -d $REPO ]; then
    echo "[/] -> $REPO"
    git -C $REPO checkout master
    git -C $REPO branch
    git -C $REPO pull
  else
    echo "[X] $REPO isn't a Git repository..."
  fi
done