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
    echo "jboss drive to stop jboss"
    rm -rf $jboss_ctrl/salescore-udv2-c1/deployments/*
    cd $extractPath/
    echo "moving deployment file DK env "
    mv distDK/*.* /$jboss_ctrl/salescore-udv2-c1/deployments
    cd $extractPath/salescore-udv2-c1
    echo "moving configurations and files of dk"
    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c1/configuration
    mv props/*.* /$jboss_ctrl/salescore-udv2-c1/props
    mv cert/*.* /$jboss_ctrl/salescore-udv2-c1/cert
    cd $jboss_ctrl/salescore-udv2-c1
    echo "start jboss"
    echo "UK Environment"
    cd $jboss_ctrl/salescore-udv2-c2
    echo "jboss drive to stop jboss"
    rm -rf $jboss_ctrl/salescore-udv2-c2/deployments/*
    cd $extractPath/
    echo "moving deployment files of UK env"
    mv distDK/*.* /$jboss_ctrl/salescore-udv2-c2/deployments
    cd $extractPath/salescore-udv2-c2
    echo "moving configurations and files of uk"
    mv configuration/*.* /$jboss_ctrl/salescore-udv2-c2/configuration
    mv props/*.* /$jboss_ctrl/salescore-udv2-c2/props
    mv cert/*.* /$jboss_ctrl/salescore-udv2-c2/cert
    cd $jboss_ctrl/salescore-udv2-c2
    echo "start jboss"
elif [[ ${Octopus_env} == "Test" ]] && [[ ${env##*-} == "c1" ]];then
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss"
    cd $extractPath/$env
    pwd
    echo "moving configurations and files of DK"
    mv configuration/*.* /$jboss_ctrl/$env/configuration
    mv props/*.* /$jboss_ctrl/$env/props
    mv cert/*.* /$jboss_ctrl/$env/cert
    echo "DK Environment"
    echo "clean up deployments"
    rm -rf $jboss_ctrl/$env/deployments/*
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------"
    pwd
    ls -al
    cd $extractPath
    mv distDK/*.* /$jboss_ctrl/$env/deployments
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------"
    ls -al
    echo "starting Jboss"
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss"
    pwd
elif [[ ${Octopus_env} == "Test" ]] && [[ ${env##*-} == "c2" ]];then
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss"
    cd $extractPath/$env
    pwd
    echo "moving configurations and files of UK "
    mv configuration/*.* /$jboss_ctrl/$env/configuration
    mv props/*.* /$jboss_ctrl/$env/props
    mv cert/*.* /$jboss_ctrl/$env/cert
    echo "present working directory is "
    pwd
    cd $extractPath
    echo "UK Environment"
    echo "clean up deployments"
    rm -rf $jboss_ctrl/$env/deployments/*
    cd $jboss_ctrl/$env/deployments
    echo "present working directory contains nothing"
    ls -al
    cd $extractPath
    mv distUK/*.* /$jboss_ctrl/$env/deployments
    cd $jboss_ctrl/$env/deployments
    echo "---------pwd--- contains deployment------"
    pwd
    ls -al
    echo "starting Jboss"
    cd $jboss_ctrl/$env
    echo "jboss drive to stop jboss"
    pwd
else
    echo "No environments are avilable for deployment"
fi
