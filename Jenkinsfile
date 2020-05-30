@NonCPS

def killPreviousRunningJobs() {
    def jobname = env.JOB_NAME
    def buildnum = env.BUILD_NUMBER.toInteger()

    def job = Jenkins.instance.getItemByFullName(jobname)
    for (build in job.builds) {
        if (!build.isBuilding()){
            continue;
        }
        if (buildnum == build.getNumber().toInteger()){
            continue;
        }
        echo "Kill task = ${build}"
        build.doStop();
    }
}

def notifyByEmail(def gitPrInfo) {
    stage('Notify') {
        String notifyPeople = "${gitPrInfo.prAuthorEmail}, ${gitPrInfo.commitAuthorEmail}"
        emailext (
            subject: "nGraph-Onnx CI: PR ${CHANGE_ID} ${currentBuild.result}!",
            body: """
                <table style="width:100%">
                    <tr><td>Status:</td> <td>${currentBuild.result}</td></tr>
                    <tr><td>Pull Request Title:</td> <td>${CHANGE_TITLE}</td></tr>
                    <tr><td>Pull Request:</td> <td><a href=${CHANGE_URL}>${CHANGE_ID}</a> </td></tr>
                    <tr><td>Branch:</td> <td>${CHANGE_BRANCH}</td></tr>
                    <tr><td>Commit Hash:</td> <td>${gitPrInfo.commitHash}</td></tr>
                    <tr><td>Commit Subject:</td> <td>${gitPrInfo.commitSubject}</td></tr>
                    <tr><td>Jenkins Build:</td> <td> <a href=${RUN_DISPLAY_URL}> ${BUILD_NUMBER} </a> </td></tr>
                </table>
            """,
            to: "${notifyPeople}"
        )
    }
}

build_badge = addEmbeddableBadgeConfiguration(id: 'build', subject: 'Build')

pipeline {
    agent { 
        docker {
            image 'sandeepk174c.mylabserver.com:8082/docker-virtual/maven:3-alpine'
            registryUrl 'http://sandeepk174c.mylabserver.com:8082'
            registryCredentialsId 'artifactorydocker'
            args '-v /var/jenkins_home/.m2:/root/.m2'
        }
    }
  //agent {
  //    // Set Build Agent as Docker file 
  //    dockerfile true
  //}
  environment {
      // Set env variables for Pipeline
      IMAGE = readMavenPom().getArtifactId()
      VERSION = readMavenPom().getVersion()
      ARTIFACTORY_SERVER_ID = "Artifactory2"
      ARTIFACTORY_URL = "http://18.130.230.19:8082/artifactory"
      ARTIFACTORY_CREDENTIALS = "admin.jfrog"
      CURRENT_BUILD_NO = "${currentBuild.number}"
      GIT_TAG = sh(returnStdout: true, script: 'git describe --tags $(git rev-list --tags --max-count=1)').trim()
      RELEASE_TAG = "${currentBuild.number}-${VERSION}"
      CURRENT_BRANCH = "${env.BRANCH_NAME}"
      OCTOHOME = "${OCTO_HOME}"
      properties = ""
      octopusURL = "https://rasmimr.octopus.app/"
  }

  stages {
    stage ('Environmental Variables') {
      steps {
          sh '''
              echo "PATH = ${PATH}"
              echo "${OCTOHOME}"
              echo "M2_HOME = ${M2_HOME}"
              echo "OCTO_HOME = ${OCTO_HOME}"
              echo "GIT_TAG = ${GIT_TAG}"
          '''
          script {
              properties = readProperties file: 'Build.properties'
              echo "${properties.testversion}"
              //env['testversion'] = props['testversion'];
              //env['company'] = props['company1'];
          }
          sh 'echo "user = ${user}"'
          sh 'echo "${testversion}"'
          //sh "echo ${env.props['company2']}"
          //sh "echo ${props['version']}"
      }
    }
    stage('Build and Deploy') {
      steps {
            withDockerContainer (image: 'busybox') {    
                         sh 'pwd'
                }
        echo "${VERSION}"
        echo "${IMAGE}"
        echo "${properties.user}"
        echo "${properties.company1}"
        echo "${properties.company2}"
        echo "${properties.company3}"
        echo "${properties.testversion}"
        echo "${CURRENT_BRANCH}"
        echo "$WORKSPACE"
        //sh 'mvn -T 100 clean deploy -B -s settings.xml'
      }
    }
    stage ('Archive Files') {
      steps {
          sh 'rm -rf dist'
          sh 'mkdir dist'
          fileOperations([
              fileCopyOperation(
                  flattenFiles: true, 
                  includes: "gameoflife-web/target/*.war", 
                  targetLocation: "$WORKSPACE/dist"), 
              fileCopyOperation(
                  flattenFiles: true, 
                  includes: "scripts/*.sh", 
                  targetLocation: "$WORKSPACE/dist"),
             folderCopyOperation(destinationFolderPath: "$WORKSPACE/dist", sourceFolderPath: "$WORKSPACE/gameoflife-core")                 
          ])
          script{currentBuild.description = "<b>Version:</b> ${VERSION}<br/>"}
          script {
            manager.addShortText("${VERSION}", "black", "lightgreen", "0px", "white")
         }
      }
    }
    stage ('Deploy to Octopus') {
      steps {
          echo " Deploy to artifactory"
          withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
              sh 'octo help'
              sh 'octo pack --id="OctoWebEng" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/DIST" --outFolder="$WORKSPACE"'
              //sh 'octo pack --id="OctoWebSwed" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/distSwed" --outFolder="$WORKSPACE"'
              sh 'octo push --package $WORKSPACE/OctoWebEng."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${APIKey}'
              //sh 'octo push --package $WORKSPACE/OctoWebSwed."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${APIKey}'
              //sh 'octo create-release --project "Java" --package="OctoWeb:${RELEASE_TAG}" --server ${octopusURL} --apiKey ${APIKey}'
              //sh 'octo deploy-release --project "Java" --version latest --deployto Dev --server ${octopusURL} --apiKey ${APIKey} --progress'
          }
          rtUpload (
              serverId: "${ARTIFACTORY_SERVER_ID}",
              spec: '''{
                  "files": [
                      {
                      "pattern": "$WORKSPACE/OctoWebEng.${RELEASE_TAG}.nupkg",
                      "target": "octopus/OctoWebEng.${RELEASE_TAG}.nupkg"
                      }
                  ]
              }''',
              buildName: "${env.JOB_NAME}",
              buildNumber: "${currentBuild.number}"
          )
          withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
              //sh 'octo pack --id="OctoWeb" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/dist" --outFolder="$WORKSPACE"'
              //sh 'octo push --package $WORKSPACE/OctoWeb."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${apiKey}'
              sh 'octo create-release --project "Tuttu" --tenant="Test1" --package="OctoWebEng:${RELEASE_TAG}" --server ${octopusURL} --apiKey ${APIKey}'
              sh 'octo deploy-release --project "Tuttu" --tenant="Test1" --version latest --deployto Dev --server ${octopusURL} --apiKey ${APIKey} --waitfordeployment'
          }
      }
    }
    stage('promote') {
        steps {
            echo "PROMOTE RELEASE"
            //withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
            //    //sh 'octo pack --id="OctoWeb" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/dist" --outFolder="$WORKSPACE"'
            //    //sh 'octo push --package $WORKSPACE/OctoWeb."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${apiKey}'
            //    sh 'octo promote-release --project "Tuttu" --tenant="Test1" --from Dev --to Test --server ${octopusURL} --apiKey ${APIKey} --waitfordeployment'
            //}
        }
    }
    stage('triggerdowstream') {
        steps {
            echo "PROMOTE RELEASE"
            script{
                def buildno = null
                build_res = build job: "gof-pipeline", wait: true
                if (build_res.result != "SUCCESS")
                {
                    color = "red"
                }
                else
                {
                    color = "green"
                }
                currentBuild.description += "<b>Commit author:</b> ${currentBuild.number}<br/>"
                currentBuild.description += '<a href=' + build_res.absoluteUrl +' style="color:' + color + '">'+ build_res.displayName + '">No#' + build_res.number + '</a><br>' + "\n" 
            }
            //withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
            //    //sh 'octo pack --id="OctoWeb" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/dist" --outFolder="$WORKSPACE"'
            //    //sh 'octo push --package $WORKSPACE/OctoWeb."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${apiKey}'
            //    sh 'octo promote-release --project "Tuttu" --tenant="Test1" --from Dev --to Test --server ${octopusURL} --apiKey ${APIKey} --waitfordeployment'
            //}
        }
    }
    stage('triggerdowstream1') {
        steps {
            echo "PROMOTE RELEASE"
            script{
                def buildno = null
                build_res = build job: "badgetest", wait: true
                if (build_res.result != "SUCCESS")
                {
                    color = "red"
                }
                else
                {
                    color = "green"
                }
                
                //currentBuild.description += '<a href=' + build_res.absoluteUrl +' style="color:' + color + '">build#'+ build_res.number + '</a><br>' + "\n"
                //buildno = "" + build_res.number
            }
            //withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
            //    //sh 'octo pack --id="OctoWeb" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/dist" --outFolder="$WORKSPACE"'
            //    //sh 'octo push --package $WORKSPACE/OctoWeb."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${apiKey}'
            //    sh 'octo promote-release --project "Tuttu" --tenant="Test1" --from Dev --to Test --server ${octopusURL} --apiKey ${APIKey} --waitfordeployment'
            //}
        }
    }
  }
  // Cleanup Workspace
  post { 
      always {
          echo 'One way or another, I have finished'
          //deleteDir()
      }
      success {
          echo 'I succeeeded!'
      }
      failure {
          echo 'I failed :('
          //deleteDir()
      }
      changed {
          echo 'Things were different before...'
      }
  }
}
