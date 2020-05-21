#!/bin/bash
echo "Predeploy process"
jboss_ctrl=$1
env=$2
extractPath=`pwd`
echo "Environment is :$env"
echo "Deployment FOLDER is :$jboss_ctrl"
cd $jboss_ctrl/$env
echo "jboss drive to stop jboss"
cd $extractPath/$env
pwd
echo "moving configurations and files "
mv configuration/*.* /$jboss_ctrl/$env/configuration
mv props/*.* /$jboss_ctrl/$env/props
mv cert/*.* /$jboss_ctrl/$env/cert
echo "present working directory is "
pwd
cd $extractPath
if [[ ${env##*-} == "c1" ]];then
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
    sleep 1m
elif [[ ${env##*-} == "c2" ]];then
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
    sleep 1m
else
    echo "No environments are avilable for deployment"
fi
echo "starting Jboss"
cd $jboss_ctrl/$env
echo "jboss drive to stop jboss"
pwd