#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
rm -rf /home/cloud_user/Documents/app1/deployments
ls -al
mv /home/cloud_user/Documents/Deployment /home/cloud_user/Documents/app1/deployments
ls -al
echo "######  Moved files to deployments path ###########"
