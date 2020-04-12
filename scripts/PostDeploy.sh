#!/bin/bash
export Tuttu_env=`get_octopusvariable "Tuttu_env"`
export Tuttu_machine=`get_octopusvariable "Tuttu_machine"`
export Tuttu_deployed=`get_octopusvariable "Tuttu_deployed"`
export Tuttu_version=`get_octopusvariable "Tuttu_version"`
echo "Tuttu Env  is---------------->: $Tuttu_env"
Releaseid=$(get_octopusvariable "Octopus.Release.Id")
Tuttumachine=$(get_octopusvariable "Octopus.Tuttu_machine")
Releaseno=$(get_octopusvariable "Octopus.Release.Number")
Releasecreated=$(get_octopusvariable "Octopus.Release.Created")
ReleasePackage=$(get_octopusvariable "Octopus.Release.Package")
ReleaseDeploymentid=$(get_octopusvariable "Octopus.Deployment.Id")
ReleaseEnvName=$(get_octopusvariable "Octopus.Environment.Name")
ReleaseProjectid=$(get_octopusvariable "Octopus.Project.Id")
echo "Releaseid is------------------>: $Releaseid"
echo "Tuttu Machine is-------------->: $Tuttumachine"
echo "Release no is----------------->: $Releaseno"
echo "Release created is------------>: $Releasecreated"
echo "Release package is------------>: $ReleasePackage"
echo "Release Deployment id is------>: $ReleaseDeploymentid"
echo "Release Environmental name is->: $ReleaseEnvName"
echo "Release Project ID is--------->: $ReleaseProjectid"
#####################################################################
echo "This is Post deploy test"
# in pre-deploy, in post-deploy if custom installation directory has not been defined
extractPath="$(get_octopusvariable "Octopus.Action.Package.CustomInstallationDirectory")"
echo "This is not needed for the testscript ----------------> : $extractPath"
# if a custom installation directory has been defined
customPath="$(get_octopusvariable "Octopus.Action.Output.Package.InstallationDirectoryPath")"
echo "This is not needed for the testscript ----------------> : $customPath"
# if a custom installation directory  where the contents of the package has been extracted
customPath="$(get_octopusvariable "Octopus.Action.Output.Package.InstallationDirectoryPath")"
echo "This is not needed for the testscript -----------------> : $customPath"

# The app we built follows "12-factor" (https://12factor.net/), and gets its 
# configuration from environment variables. The variables we set in this session
# are captured by PM2 and stored for the application (so even if the app is 
# restarted in a different session, it uses these variables)

# Change to the directory where our Node.js app was extracted
cd `get_octopusvariable "Octopus.Action[dev package].Output.Package.InstallationDirectoryPath"`
echo "##Present working directory is-------------------------------------------------->"
pwd
ls -l 

# Start PM2
# PM2 instance name: Phoenix_Tenant
InstanceName="Phoenix_#{Tuttu_env}_#{Tuttu_machine}"

echo "##octopus instance name --------------------------------------->: $InstanceName"
#pm2 stop "$InstanceName"
#pm2 delete "$InstanceName"

#echo "##octopus[stderr-default]"
#pm2 start ./bin/www --name "$InstanceName"
