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
      ARTIFACTORY_URL = "http://192.168.0.104:8082/artifactory"
      ARTIFACTORY_CREDENTIALS = "admin.jfrog"
      CURRENT_BUILD_NO = "${currentBuild.number}"
      RELEASE_TAG = "${currentBuild.number}-${VERSION}"
      CURRENT_BRANCH = "${env.BRANCH_NAME}"
      OCTOHOME = "${OCTO_HOME}"
  }

  stages {
    stage ('Environmental Variables') {
      steps {
          sh '''
              echo "PATH = ${PATH}"
              echo "${OCTOHOME}"
              echo "M2_HOME = ${M2_HOME}"
              echo "OCTO_HOME = ${OCTO_HOME}"
          '''
          script {
              def props = readProperties file:'Build.properties';
              env['foo'] = props['user'];
          }
          sh 'echo "foo = ${foo}"'
          sh "echo ${props['company1']}"
          sh "echo ${props['company2']}"
          sh "echo ${props['version']}"
      }
    }
    stage('Build and Deploy') {
      steps {
        echo "${VERSION}"
        echo "${IMAGE}"
        echo "${CURRENT_BRANCH}"
        echo "$WORKSPACE"
        sh 'mvn clean deploy -s settings.xml'
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
                  targetLocation: "$WORKSPACE/dist") 
          ])
      }
    }
    stage ('Deploy to Octopus') {
      steps {
          echo " Deploy to artifactory"
          withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
              sh 'octo help'
              sh 'octo pack --id="OctoWeb" --version="${RELEASE_TAG}" --basePath="$WORKSPACE/dist" --outFolder="$WORKSPACE"'
          }
          rtUpload (
              serverId: "${ARTIFACTORY_SERVER_ID}",
              spec: '''{
                  "files": [
                      {
                      "pattern": "$WORKSPACE/OctoWeb.${RELEASE_TAG}.nupkg",
                      "target": "octopus/OctoWeb.${RELEASE_TAG}.nupkg"
                      }
                  ]
              }''',
              buildName: "${env.JOB_NAME}",
              buildNumber: "${currentBuild.number}"
          )
      }
    }
  }
}
