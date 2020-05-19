#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package[OctoWebEng].InstallationDirectoryPath")"
echo "--------------------$extractPath---------------------"
ls -al
echo "-------------------moved files---------------------"
echo "######  Moved files to deployments path ###########"