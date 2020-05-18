pipeline {
  agent {
      // Set Build Agent as Docker file 
      dockerfile true
  }
  environment {
      // Set env variables for Pipeline
      IMAGE = readMavenPom().getArtifactId()
      VERSION = readMavenPom().getVersion()
      ARTIFACTORY_SERVER_ID = "Artifactory1"
      ARTIFACTORY_URL = "http://192.168.0.102:8082/artifactory"
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
        echo "${VERSION}"
        echo "${IMAGE}"
        echo "${properties.user}"
        echo "${properties.company1}"
        echo "${properties.company2}"
        echo "${properties.company3}"
        echo "${properties.testversion}"
        echo "${CURRENT_BRANCH}"
        echo "$WORKSPACE"
        sh 'mvn -T 100 clean deploy -B -s settings.xml'
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
      }
    }
    stage ('Deploy to Octopus') {
      steps {
          echo " Deploy to artifactory"
          withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
              sh 'octo help'
              sh 'octo pack --id="OctoWebEng" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/distEng" --outFolder="$WORKSPACE"'
              sh 'octo pack --id="OctoWebSwed" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/distSwed" --outFolder="$WORKSPACE"'
              sh 'octo push --package $WORKSPACE/OctoWebEng."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${APIKey}'
              sh 'octo push --package $WORKSPACE/OctoWebSwed."${RELEASE_TAG}".nupkg --replace-existing --server ${octopusURL} --apiKey ${APIKey}'
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
              sh 'octo create-release --project "Tuttu" --package="OctoWebEng:${RELEASE_TAG}" --server ${octopusURL} --apiKey ${APIKey}'
              sh 'octo deploy-release --project "Tuttu" --version latest --deployto Dev --server ${octopusURL} --apiKey ${APIKey} --waitfordeployment'
          }
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
