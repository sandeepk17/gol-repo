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
echo "OCTOPUS ENVIRONMENT is :$Octopus_env"

if [[ ${Octopus_env} == "Dev" ]];then
    echo "DK Environment"
    cd $jboss_ctrl/salescore-udv2-c1
    echo "jboss drive to stop jboss 1"
    rm -rf $jboss_ctrl/salescore-udv2-c1/deployments/*
    cd $extractPath/
    echo "moving deployment file DK env 2"
    mv distDK/*.* /$jboss_ctrl/salescore-udv2-c1/deployments
    cd $extractPath/salescore-udv2-c1
    echo "moving configurations and files of dk 3"
    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c1/configuration
    mv props/*.* /$jboss_ctrl/salescore-udv2-c1/props
    mv cert/*.* /$jboss_ctrl/salescore-udv2-c1/cert
    cd $jboss_ctrl/salescore-udv2-c1
    echo "start jboss 4"
    echo "UK Environment 5"
    cd $jboss_ctrl/salescore-udv2-c2
    echo "jboss drive to stop jboss 6 "
    rm -rf $jboss_ctrl/salescore-udv2-c2/deployments/*
    cd $extractPath/
    echo "moving deployment files of UK env 7"
    mv distUK/*.* /$jboss_ctrl/salescore-udv2-c2/deployments
    cd $extractPath/salescore-udv2-c2
    echo "moving configurations and files of uk 8"
    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c2/configuration
    mv props/*.* /$jboss_ctrl/salescore-udv2-c2/props
    mv cert/*.* /$jboss_ctrl/salescore-udv2-c2/cert
    cd $jboss_ctrl/salescore-udv2-c2
    echo "start jboss 9"
    pwd
elif [[ $Octopus_env == "Test" ]] && [[ ${env##*-} == "c1" ]];then
    echo "-************************$Octopus_env 10"
    echo "TESTING ENVIRONMENT-----$Octopus_env 11"
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss 12"
    cd $extractPath/$env
    pwd
    echo "moving configurations and files of DK 13"
    mv configuration/*.* /$jboss_ctrl/$env/configuration
    mv props/*.* /$jboss_ctrl/$env/props
    mv cert/*.* /$jboss_ctrl/$env/cert
    echo "DK Environment 14"
    echo "clean up deployments 15"
    rm -rf $jboss_ctrl/$env/deployments/*
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------16"
    pwd
    ls -al
    cd $extractPath
    mv distDK/*.* /$jboss_ctrl/$env/deployments
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------"
    ls -al
    echo "starting Jboss 17"
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss 18"
    pwd
elif [[ $Octopus_env == "Test" ]] && [[ ${env##*-} == "c2" ]];then
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss 19"
    cd $extractPath/$env
    pwd
    echo "moving configurations and files of UK 20"
    mv configuration/*.* /$jboss_ctrl/$env/configuration
    mv props/*.* /$jboss_ctrl/$env/props
    mv cert/*.* /$jboss_ctrl/$env/cert
    echo "present working directory is 21"
    pwd
    cd $extractPath
    echo "UK Environment 22"
    echo "clean up deployments 23"
    rm -rf $jboss_ctrl/$env/deployments/*
    cd $jboss_ctrl/$env/deployments
    echo "present working directory contains nothing 24"
    ls -al
    cd $extractPath
    mv distUK/*.* /$jboss_ctrl/$env/deployments
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------25"
    pwd
    ls -al
    echo "starting Jboss 26"
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss 27"
    pwd
else
    echo "No environments are avilable for deployment 28"
fi
