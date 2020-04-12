#!/bin/bash
echo "#######################################"
echo "######      PRE DEPLOY      ###########"
echo "#######################################"
ls -al
echo "This is Predeploy test of PreDeploy ENVIRONMENT SCRIPT "
# in pre-deploy, in post-deploy if custom installation directory has not been defined
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "This is extract path ---------------> : $extractPath"
# if a custom installation directory has been defined
customPath="$(get_octopusvariable "Octopus.Action.Package.CustomInstallationDirectory")"
echo "This is custom path -----------------> : $customPath"
# in pre-deploy, in post-deploy if custom installation directory has not been defined
extractPath1="$(get_octopusvariable "Octopus.Action.Package[dev package].CustomInstallationDirectory")"
echo "This is extract path1 ----------------> : $extractPath1"