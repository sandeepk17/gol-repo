#!/bin/bash
Releaseid=$(get_octopusvariable "Octopus.Release.Id")
Releaseno=$(get_octopusvariable "Octopus.Release.Number")
Releasecreated=$(get_octopusvariable "Octopus.Release.Created")
ReleasePackage=$(get_octopusvariable "Octopus.Release.Package")
ReleaseDeploymentid=$(get_octopusvariable "Octopus.Deployment.Id")
ReleaseEnvName=$(get_octopusvariable "Octopus.Environment.Name")
ReleaseProjectid=$(get_octopusvariable "Octopus.Project.Id")
echo "Releaseid Connection string is: $Releaseid"
echo "Release no Connection string is: $Releaseno"
echo "Release created Connection string is: $Releasecreated"
echo "Release package Connection string is: $ReleasePackage"
echo "Release Deployment Connection string is: $ReleaseDeploymentid"
echo "Release Environmental name Connection string is: $ReleaseEnvName"
echo "Release Project ID Connection string is: $ReleaseProjectid"
#####################################################################
echo "This is Post deploy test"
echo "This is not needed for the testscript ----> : $1"
# in pre-deploy, in post-deploy if custom installation directory has not been defined
extractPath="$(get_octopusvariable "Octopus.Action.Package.CustomInstallationDirectory")"
echo "This is not needed for the testscript ----> : $extractPath"
# if a custom installation directory has been defined
customPath="$(get_octopusvariable "Octopus.Action.Output.Package.InstallationDirectoryPath")"
echo "This is not needed for the testscript ----> : $customPath"
# if a custom installation directory  where the contents of the package has been extracted
customPath="$(get_octopusvariable "Octopus.Action.Output.Package.InstallationDirectoryPath")"
echo "This is not needed for the testscript ----> : $customPath"