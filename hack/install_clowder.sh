#!/bin/bash  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..
# check out your own copy first and it will use it, instead of cloning a new one
CLOWDER=$ROOT/../clowder 
if [ ! -d $CLOWDER ]; then 
  echo "No clowder found in $CLOWDER"
  echo "Cloning it into the parent directory for installation." 
  git clone https://github.com/RedHatInsights/clowder.git $CLOWDER 
fi 
(cd $CLOWDER; ./build/kube_setup.sh)