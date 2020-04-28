#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "--------------------4---------------------"
ls -al
echo "-------------------moved files---------------------"
echo "######  Moved files to deployments path ###########"
