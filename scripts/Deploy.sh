#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
mv /home/cloud_user/Documents/Deployment /home/cloud_user/Documents/app1/deployments
echo "######  Moved files to deployments path ###########"
