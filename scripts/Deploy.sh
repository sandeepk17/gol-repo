#!/bin/bash
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "--------------------4---------------------"
rm -rf /home/cloud_user/Documents/app1/deployments
ls -al
echo "-------------------moved files---------------------"
mv /home/cloud_user/Documents/Deployment /home/cloud_user/Documents/app1/deployments
ls -al
echo "######  Moved files to deployments path ###########"
