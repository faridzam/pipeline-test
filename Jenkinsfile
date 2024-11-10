pipeline {

  environment {
    dockerimagename = "faridzam/pipeline-test"
    dockerImage = ""
  }
  
  agent any

  stages {

    stage('Checkout Source') {
      steps {
        withCredentials([string(credentialsId: 'faridzam-github-token', variable: 'GITHUB_TOKEN')]) {
            git url: 'https://github.com/faridzam/pipeline-test.git', credentialsId: 'faridzam-github-token'
        }
      }
    }

    // stage('Initialize Docker') {
    //   steps{
    //     script {
    //       def dockerHome = tool 'jenkins-docker'
    //       env.PATH = "${dockerHome}/bin:${env.PATH}"
    //     }
    //   }
    // }

    // stage('Start Docker Daemon') {
    //   steps {
    //     sh '''
    //       sudo systemctl start docker  # Start Docker as a system service
    //       sudo systemctl status docker  # Check status
    //       sleep 5  # Wait for Docker daemon to start
    //       docker run --rm hello-world
    //     '''
    //   }
    // }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    // stage('Pushing Image') {
    //   environment {
    //     registryCredential = 'faridzam-dockerhub-login'
    //   }
    //   steps{
    //     script {
    //       docker.withRegistry( 'https://hub.docker.com', registryCredential ) {
    //         dockerImage.push("latest")
    //       }
    //     }
    //   }
    // }

    // stage('Deploying App to Kubernetes') {
    //   steps {
    //     script {
    //       kubernetesDeploy(configs: "deployment-service.yml")
    //     }
    //   }
    // }

    // stage('Remove Unused docker image') {
    //   steps{
    //     sh "docker rmi $imagename:$BUILD_NUMBER"
    //     sh "docker rmi $imagename:latest"
    //   }
    // }

  }

}