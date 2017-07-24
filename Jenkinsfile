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
        sh "docker build --pull --rm -t dr.haak.co/mariadb-alpine ."
        sh "docker tag dr.haak.co/mariadb-alpine:latest dr.haak.co/mariadb-alpine:${env.GIT_COMMIT}"
      }
    }
    stage ('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'bamboo_dr_haak_co', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh "docker login --username ${USERNAME} --password ${PASSWORD} https://dr.haak.co"
          sh "docker push dr.haak.co/mariadb-alpine:latest"
          sh "docker push dr.haak.co/mariadb-alpine:${env.GIT_COMMIT}"
        }
      }
    }
  }
}
