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
      ARTIFACTORY_URL = "http://192.168.0.114:8082/artifactory"
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
    stage ('Deploy to Octopus') {
      steps {
          echo " Deploy to artifactory"
          withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
              sh 'octo help'
              sh 'octo pack --id="OctoWeb" --version="1.0.0" --basePath="$WORKSPACE/gameoflife-web/target/gameoflife.war" --outFolder="$WORKSPACE"'
          }
      }
    }
  }
}
