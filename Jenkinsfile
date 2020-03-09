pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/EasyLinux/game-of-life-1.git'
      }
    }
    stage('Lancer les tests') {
      steps {
        sh 'mvn verify'
      }
    }
    stage('Anlyse de code') {
      steps {
        sh 'mvn cobertura'
      }
    }
  }
}
