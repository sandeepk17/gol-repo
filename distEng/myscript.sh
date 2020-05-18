#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo"-----------------------------"
echo "$extractPath"
echo"----------------------------------"
ls -al
echo "-------------------moved files---------------------"
echo "######  Moved files to deployments path ###########"
echo "................pwd....."
echo "................$1....."