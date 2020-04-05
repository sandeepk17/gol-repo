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
    stage('Build and Deploy') {
      steps {
        sh 'mvn deploy -s settings.xml'
      }
    }
  }
}
