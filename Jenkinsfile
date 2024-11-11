pipeline {
  
  agent any

  tools{
    dockerTool 'jenkins-docker'
  }

  environment {
    dockerPath = "${tool 'jenkins-docker'}/bin/docker"
    dockerImageName = "faridzam/pipeline-test"
    dockerImage = ""
  }

  stages {

    stage('Checkout Source') {
      steps {
        withCredentials([string(credentialsId: 'faridzam-github-token', variable: 'GITHUB_TOKEN')]) {
            git url: 'https://github.com/faridzam/pipeline-test.git', credentialsId: 'faridzam-github-token'
        }
      }
    }

    stage('Build image') {
      steps{
        script {
          // dockerImage = docker.build dockerimagename
          sh "${dockerPath} build -t ${dockerImageName}"
        }
      }
    }

    stage('Pushing Image') {
      environment {
        registryCredential = 'faridzam-dockerhub-login'
      }
      steps{
        script {
          // docker.withRegistry( 'https://index.docker.io/v1/', registryCredential ) {
          //   dockerImage.push("latest")
          // }

          // Login to Docker registry
          sh """
          echo \$DOCKER_PASSWORD | ${dockerPath} login -u \$DOCKER_USERNAME --password-stdin
          """
          // Push the Docker image
          sh "$dockerPath push $dockerimagename:latest"
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
        script{
          dockerImage.remove()
        }
      }
    }

  }

}