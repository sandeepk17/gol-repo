#!/bin/bash
echo "#################5####################"
echo "######          post DEPLOY      ###########"
echo "#######################################"
export Tuttu_env=`get_octopusvariable "Tuttu_env"`
export Tuttu_machine=`get_octopusvariable "Tuttu_machine"`
export Tuttu_deployed=`get_octopusvariable "Tuttu_deployed"`
export Tuttu_version=`get_octopusvariable "Tuttu_version"`
echo "######### Variable as Environmental VAriable ###########"
echo "Tuttu Env  is---------------->: $Tuttu_env"
echo "Tuttu Machine  is---------------->: $Tuttu_machine"
echo "############## RELEASE VARIABLES #######################"
Releaseid=$(get_octopusvariable "Octopus.Release.Id")
Tuttumachine=$(get_octopusvariable "Tuttu_machine")
Releaseno=$(get_octopusvariable "Octopus.Release.Number")
Releasecreated=$(get_octopusvariable "Octopus.Release.Created")
ReleasePackage=$(get_octopusvariable "Octopus.Release.Package")
ReleaseDeploymentid=$(get_octopusvariable "Octopus.Deployment.Id")
ReleaseEnvName=$(get_octopusvariable "Octopus.Environment.Name")
ReleaseProjectid=$(get_octopusvariable "Octopus.Project.Id")
echo "######################################################"
echo "Releaseid is==================>: $Releaseid"
echo "Tuttu Machine is-------------->: $Tuttumachine"
echo "Release no is----------------->: $Releaseno"
echo "Release created is------------>: $Releasecreated"
echo "Release package is------------>: $ReleasePackage"
echo "Release Deployment id is------>: $ReleaseDeploymentid"
echo "Release Environmental name is->: $ReleaseEnvName"
echo "Release Project ID is--------->: $ReleaseProjectid"
echo "#######################################################"
echo "<=============This is Post deploy SCRIPT ================>"

# if a custom installation directory  where the contents of the package has been extracted
customPath="$(get_octopusvariable "Octopus.Action.Output.Package[dev package].InstallationDirectoryPath")"
echo "This is custom path =================>: $customPath"

# Change to the directory where our Node.js app was extracted
cd `get_octopusvariable "Octopus.Action[dev package].Output.Package.InstallationDirectoryPath"`
echo "##Present working directory is =================================>"
pwd
ls -l 

InstanceName="Phoenix_`get_octopusvariable "Tuttu_machine"`"

echo "##octopus instance name ===============================>: $InstanceName"
