pipeline {
  
  agent any

  tools{
    dockerTool 'jenkins-docker'
  }

  environment {
    kubeConfig = '/.kube/config'
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
          sh "${dockerPath} build -t ${dockerImageName} ."
        }
      }
    }

    stage('Pushing Image') {
      environment {
        registryCredential = 'faridzam-dockerhub-login'
      }
      steps{
        script {
          // Docker login using credentials from Jenkins
          withCredentials([usernamePassword(credentialsId: registryCredential, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh """
            ${dockerPath} login -u \$DOCKER_USERNAME --password=\$DOCKER_PASSWORD
            """
          }
          // Push the Docker image
          sh "$dockerPath push $dockerImageName:latest"
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deployment-service.yml", kubeConfig: kubeConfig)
        }
      }
    }

    stage('Remove Unused docker image') {
      steps{
        script{
          sh "${dockerPath} rmi $(${dockerpath} images | grep ${dockerImageName})"
        }
      }
    }

  }

}