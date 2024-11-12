pipeline {

  environment {
    DOCKER_IMAGE_NAME = "faridzam/pipeline-test-dev"
    REGISTRY_CREDENTIALS_ID = "faridzam-docker-credentials"
    NAMESPACE = 'devops-tools'
    REPO_URL = 'https://github.com/faridzam/pipeline-test.git'
    BRANCH = 'dev'
    DEPLOYMENT_YAML = 'deployment-service.yml'
  }

  agent any

  stages {

    stage('Build image') {
      steps{
        script {
          sh "docker build -t ${DOCKER_IMAGE_NAME} ."
        }
      }
    }

    stage('Pushing Image') {
      steps{
        script {
          // Docker login using credentials from Jenkins
          withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh """
              docker login -u \$DOCKER_USERNAME --password=\$DOCKER_PASSWORD
            """
          }
          // Push the Docker image
          sh "docker push $DOCKER_IMAGE_NAME"
        }
      }
    }

    stage('Setup Kubernetes Namespace') {
      steps {
        script {
          sh("kubectl get ns ${env.NAMESPACE} || kubectl create ns ${env.NAMESPACE}")
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          sh "kubectl apply -f ${env.DEPLOYMENT_YAML} -n ${env.NAMESPACE}"
        }
      }
    }

    stage('Remove Unused docker image') {
      steps{
        script{
          sh "docker image prune -a"
        }
      }
    }

  }

}