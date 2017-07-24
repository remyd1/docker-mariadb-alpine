pipeline {
  agent any

  stages {
    stage ('Checkout Code') {
      steps {
        checkout scm
      }
    }
    stage ('Verify Tools'){
      steps {
        parallel (
          docker: { sh "docker -v" }
        )
      }
    }

    stage ('Build container') {
      steps {
        sh "docker build --pull --rm -t timhaak/mariadb-alpine ."
        sh "docker tag timhaak/mariadb-alpine:latest timhaak/mariadb-alpine:${env.GIT_COMMIT}"
      }
    }
    stage ('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'bamboo_dr_haak_co', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh "docker login --username ${USERNAME} --password ${PASSWORD} https://dr.haak.co"
          sh "docker push timhaak/mariadb-alpine:latest"
          sh "docker push timhaak/mariadb-alpine:${env.GIT_COMMIT}"
        }
      }
    }
  }
}
