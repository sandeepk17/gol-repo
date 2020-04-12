#!/bin/bash
ls -al
echo "This is Predeploy test of DEV ENVIRONMENT "
echo "This is not needed for the testscript ----> : $1"
# in pre-deploy, in post-deploy if custom installation directory has not been defined
extractPath="$(get_octopusvariable "Octopus.Action.Package.InstallationDirectoryPath")"
echo "This is not needed for the testscript ----> : $extractPath"
# if a custom installation directory has been defined
customPath="$(get_octopusvariable "Octopus.Action.Package.CustomInstallationDirectory")"
echo "This is not needed for the testscript ----> : $customPath"