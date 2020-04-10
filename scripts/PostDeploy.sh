#!/bin/bash
Releaseid=$(get_octopusvariable "Octopus.Release.Id")
Releaseno=$(get_octopusvariable "Octopus.Release.Number")
Releasecreated=$(get_octopusvariable "Octopus.Release.Created")
ReleasePackage=$(get_octopusvariable "Octopus.Release.Package")
ReleaseDeploymentid=$(get_octopusvariable "Octopus.Deployment.Id")
ReleaseEnvName=$(get_octopusvariable "Octopus.Environment.Name")
ReleaseProjectid=$(get_octopusvariable "Octopus.Project.Id")
echo "Connection string is: $Releaseid"
echo "Connection string is: $Releaseno"
echo "Connection string is: $Releasecreated"
echo "Connection string is: $ReleasePackage"
echo "Connection string is: $ReleaseDeploymentid"
echo "Connection string is: $ReleaseEnvName"
echo "Connection string is: $ReleaseProjectid"
echo "This is Post deploy test"