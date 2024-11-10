pipeline {

  environment {
    dockerimagename = "faridzam/pipeline-test"
    dockerImage = ""
  }
  
  agent any

  tools{
    dockerTool 'jenkins-docker'
  }

  stages {

    stage('Checkout Source') {
      steps {
        withCredentials([string(credentialsId: 'faridzam-github-token', variable: 'GITHUB_TOKEN')]) {
            git url: 'https://github.com/faridzam/pipeline-test.git', credentialsId: 'faridzam-github-token'
        }
      }
    }

    // stage('Build image') {
    //   steps{
    //     script {
    //       dockerImage = docker.build dockerimagename
    //     }
    //   }
    // }

    stage('Build and Pushing Image') {
      environment {
        registryCredential = 'faridzam-dockerhub-login'
      }
      steps{
        script {
          dockerImage = docker.build dockerimagename
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deployment-service.yml")
        }
      }
    }

    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:$BUILD_NUMBER"
        sh "docker rmi $imagename:latest"
      }
    }

  }

}