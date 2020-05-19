#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
echo "-================================-"
pwd
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "--------------------$extractPath---------------------"
ls -al
echo "-------------------moved files---------------------"
echo "######  Moved files to deployments path ###########"
echo "-----------first---------$1---------------------"
echo "---------second-----------$2---------------------"
echo "-------devenvpackage------$3----------------------"
cd $1
pwd