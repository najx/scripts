#!/bin/bash

# ANSI color code variables
red="\x1b[31m"
blue="\x1b[34m"
green="\x1b[32m"
yellow="\x1b[33m"
reset="\x1b[0m"

x=$1

display() {
  case "$issue" in
    "1")
      echo -e "  ${red}One parameter must be specified with this script and must be an existing path${reset}"
      echo -e "  ${red}^^^${reset}"
      ;;
    "2")
      echo -e "  ${red}The specified directory does not exist${reset}"
      ;;
    "3")
      echo -e "The parameter ${red}must be a path${reset} and has to be specified as follow:"
      echo -e "              ${red}^^^^^^^^^^^^^^${reset}"
      echo
      echo -e "  ${green}[/]${reset}     allowed format: ${yellow}/dir1/dir2${reset}"
      echo -e "  ${red}[X]${reset} Not allowed format: ${yellow}/dir1/dir2${reset}${red}/${reset}"
      ;;
  esac
}

echo
if [ -z $1 ] || ! [ -z $2 ]; then
  issue=1
  display issue
  exit 2
fi

if ! [ -a $1 ]; then
  issue=2
  display issue
  exit 2
fi

if [ "${x:${#x}-1}" == "/" ]; then
  issue=3
  display issue
  exit 2
fi

i=1
for val in $*; do
  echo -e "PARAM(${blue}$i${reset}): ${blue}$val${reset}"
  ((i++))
done

echo
for file in `ls $1`; do
  REPO="$1/$file"
  if [ -d $REPO ]; then
    if [ -a $REPO"/.git" ]; then
      echo -e "${green}[/]${reset} -> $REPO"
      git -C $REPO checkout master
      git -C $REPO pull
      echo
    else
      echo
      echo -e "${yellow}[X] $REPO isn't a Git repository...${reset}"
      echo
    fi
  else
    echo
    echo -e "${yellow}[X] $REPO isn't a directory...${reset}"
    echo
  fi
done