#!/bin/bash
echo "#######################################"
echo "######      PRE DEPLOY      ###########"
echo "#######################################"
ls -al
echo "This is Predeploy test of PreDeploy ENVIRONMENT SCRIPT "
# in pre-deploy, in post-deploy if custom installation directory has not been defined
echo "--------------------1---------------------"
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "This is extract path ---------------> : $extractPath"
cd $extractPath
ls -al
# if a custom installation directory has been defined
echo "--------------------2--------------------"
customPath="$(get_octopusvariable "Octopus.Action.Package.CustomInstallationDirectory")"
echo "This is custom path -----------------> : $customPath"
cd $customPath
ls -al
# in pre-deploy, in post-deploy if custom installation directory has not been defined
echo "--------------------3---------------------"
extractPath1="$(get_octopusvariable "Octopus.Action.Package[dev package].CustomInstallationDirectory")"
echo "This is extract path1 ----------------> : $extractPath1"