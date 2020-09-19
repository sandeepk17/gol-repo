#!/bin/bash
set +e
echo "#######################################"
echo "######          DEPLOY      ###########"
echo "#######################################"
echo "-================================-"
jboss_ctrl=$1
env=$2
Octopus_env="$(get_octopusvariable "Octopus.Environment.Name")"
extractPath=`pwd`
echo "Environment is :$env"
echo "Deployment FOLDER is :$jboss_ctrl"
echo "extract path is :$extractPath"
ls -al
octopuspackageversion=$(get_octopusvariable "Octopus.Action.Package.PackageVersion")
octopuspackagename=$(get_octopusvariable "Octopus.Action.Package.PackageId")
testpasswd=$(get_octopusvariable "test_password")
ssh_variable=$(get_octopusvariable "ssh_variable")
echo "OCTOPUS ENVIRONMENT is :$Octopus_env"
deployer=$(get_octopusvariable "Octopus.Deployment.CreatedBy.DisplayName")
deployment_date=$(get_octopusvariable "Octopus.Deployment.Created")
deployment_id=$(get_octopusvariable "Octopus.Deployment.Id")
deployment_name=$(get_octopusvariable "Octopus.Deployment.Name")
release_id=$(get_octopusvariable "Octopus.Release.Id")
release_number=$(get_octopusvariable "Octopus.Release.Number")
tuttu_number=$(get_octopusvariable "tuttu_version")
tuttu_env=$(get_octopusvariable "env_name")
echo "deployer is :$deployer"
echo "deployment_date :$deployment_date"
echo "deployment_id is :$deployment_id"
echo "deployment_name is :$deployment_name"
echo "release_id is :$release_id"
echo "DevEnvPackage is :$DevEnvPackage"
echo "env is :$env"
echo "env_name is :$env_name"
echo "jboss is :$jboss"
echo "jboss is :#{jboss}"
echo "salescore_language is :#{salescore_language}"
echo "tuttu_env is :#{tuttu_env}"
echo "tuttu machine is :#{tuttu_machine}"
echo "tuttu env is :#{tuttu_env}"
echo "environment test library is :#{env_test_lib}"
echo "#######################################"
echo "test passwd is :${testpasswd}"
echo "sshvariable is :${ssh_variable}"
echo "##################cat tst.ssh#####################"
cat tst.ssh
echo "#######################################"
echo "package version is--------->: $octopuspackageversion"
echo "package name is--------->: $octopuspackagename"
echo "---------------------------"
cat id_rsa.pub
echo "---------------------------"
if [[ ${Octopus_env} == "Dev" ]];then
echo "DK Environment"
elif [[$Octopus_env == "Test" ]] && [[ ${env##*-} == "DK" ]];then
echo "Test Environment DK environment"
elif [[ $Octopus_env == "Test" ]] && [[ ${env##*-} == "UK" ]];then
echo "Test Environment UK environment"
fi

#if [[ ${Octopus_env} == "Dev" ]];then
#    echo "DK Environment"
#    cd $jboss_ctrl/salescore-udv2-c1
#    echo "jboss drive to stop jboss 1"
#    rm -rf $jboss_ctrl/salescore-udv2-c1/deployments/*
#    cd $extractPath/
#    echo "moving deployment file DK env 2"
#    mv distDK/*.* /$jboss_ctrl/salescore-udv2-c1/deployments
#    cd $extractPath/salescore-udv2-c1
#    echo "moving configurations and files of dk 3"
#    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c1/configuration
#    mv props/*.* /$jboss_ctrl/salescore-udv2-c1/props
#    mv cert/*.* /$jboss_ctrl/salescore-udv2-c1/cert
#    cd $jboss_ctrl/salescore-udv2-c1
#    echo "start jboss 4"
#    echo "UK Environment 5"
#    cd $jboss_ctrl/salescore-udv2-c2
#    echo "jboss drive to stop jboss 6 "
#    rm -rf $jboss_ctrl/salescore-udv2-c2/deployments/*
#    cd $extractPath/
#    echo "moving deployment files of UK env 7"
#    mv distUK/*.* /$jboss_ctrl/salescore-udv2-c2/deployments
#    cd $extractPath/salescore-udv2-c2
#    echo "moving configurations and files of uk 8"
#    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c2/configuration
#    mv props/*.* /$jboss_ctrl/salescore-udv2-c2/props
#    mv cert/*.* /$jboss_ctrl/salescore-udv2-c2/cert
#    cd $jboss_ctrl/salescore-udv2-c2
#    echo "start jboss 9"
#    pwd
#elif [[ $Octopus_env == "Test" ]] && [[ ${env##*-} == "c1" ]];then
#    echo "-************************$Octopus_env 10"
#    echo "TESTING ENVIRONMENT-----$Octopus_env 11"
#    cd $jboss_ctrl/$env
#    echo "jboss drive to stop jboss 12"
#    cd $extractPath/$env
#    pwd
#    echo "moving configurations and files of DK 13"
#    mv configuration/*.* /$jboss_ctrl/$env/configuration
#    mv props/*.* /$jboss_ctrl/$env/props
#    mv cert/*.* /$jboss_ctrl/$env/cert
#    echo "DK Environment 14"
#    echo "clean up deployments 15"
#    rm -rf $jboss_ctrl/$env/deployments/*
#    cd $jboss_ctrl/$env/deployments
#    echo "---------pwd--- contains deployment------16"
#    pwd
#    ls -al
#    cd $extractPath
#    mv distDK/*.* /$jboss_ctrl/$env/deployments
#    cd $jboss_ctrl/$env/deployments
#    echo "---------pwd--- contains deployment------"
#    ls -al
#    echo "starting Jboss 17"
#    cd $jboss_ctrl/$env
#    echo "jboss drive to stop jboss 18"
#    pwd
#elif [[ $Octopus_env == "Test" ]] && [[ ${env##*-} == "c2" ]];then
#    cd $jboss_ctrl/$env
#    echo "jboss drive to stop jboss 19"
#    cd $extractPath/$env
#    pwd
#    echo "moving configurations and files of UK 20"
#    mv configuration/*.* /$jboss_ctrl/$env/configuration
#    mv props/*.* /$jboss_ctrl/$env/props
#    mv cert/*.* /$jboss_ctrl/$env/cert
#    echo "present working directory is 21"
#    pwd
#    cd $extractPath
#    echo "UK Environment 22"
#    echo "clean up deployments 23"
#    rm -rf $jboss_ctrl/$env/deployments/*
#    cd $jboss_ctrl/$env/deployments
#    echo "present working directory contains nothing 24"
#    ls -al
#    cd $extractPath
#    mv distUK/*.* /$jboss_ctrl/$env/deployments
#    cd $jboss_ctrl/$env/deployments
#    echo "---------pwd--- contains deployment------25"
#    pwd
#    ls -al
#    echo "starting Jboss 26"
#    cd $jboss_ctrl/$env
#    echo "jboss drive to stop jboss 27"
#    pwd
#else
#    echo "No environments are avilable for deployment 28"
#fi
