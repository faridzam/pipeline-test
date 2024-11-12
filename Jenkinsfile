pipeline {
  
  tools{
    dockerTool 'jenkins-docker'
  }

  environment {
    DOCKER_PATH = "${tool 'jenkins-docker'}/bin/docker"
    DOCKER_IMAGE_NAME = "faridzam/pipeline-test"
    REGISTRY_CREDENTIALS_ID = "faridzam-dockerhub-login"
    KUBERNETES_CREDENTIALS_ID = 'kubernetes-config'
    KUBERNETES_SERVER_URL = 'https://192.168.18.101:6443'
    NAMESPACE = 'devops-tools'
    REPO_URL = 'https://github.com/faridzam/pipeline-test.git'
    BRANCH = 'dev'
    DEPLOYMENT_YAML = 'deployment-service.yml'
  }

  agent {
    kubernetes {
      inheritFrom 'kube-slave-pod-1'
      yaml '''
        spec:
          containers:
          - name: kubectl
            image: bitnami/kubectl:latest
            command:
            - cat
            tty: true
          - name: jnlp
            image: jenkins/inbound-agent
            args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
      '''
    }
  }

  // agent any

  stages {

    // stage('Checkout Source') {
    //   steps {
    //     withCredentials([string(credentialsId: 'faridzam-github-token', variable: 'GITHUB_TOKEN')]) {
    //         git url: 'https://github.com/faridzam/pipeline-test.git', credentialsId: 'faridzam-github-token'
    //     }
    //   }
    // }

    // stage('Build image') {
    //   steps{
    //     script {
    //       sh "${DOCKER_PATH} build -t ${DOCKER_IMAGE_NAME} ."
    //     }
    //   }
    // }

    // stage('Pushing Image') {
    //   steps{
    //     script {
    //       // Docker login using credentials from Jenkins
    //       withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
    //         sh """
    //         ${DOCKER_PATH} login -u \$DOCKER_USERNAME --password=\$DOCKER_PASSWORD
    //         """
    //       }
    //       // Push the Docker image
    //       sh "$DOCKER_PATH push $DOCKER_IMAGE_NAME"
    //     }
    //   }
    // }

    // stage('Setup Kubernetes Context') {
    //   steps {
    //     script {
    //       withKubeConfig([credentialsId: env.KUBERNETES_CREDENTIALS_ID, serverUrl: env.KUBERNETES_SERVER_URL, namespace: env.NAMESPACE]) {
    //         sh("kubectl get ns ${env.NAMESPACE} || kubectl create ns ${env.NAMESPACE}")
    //       }
    //     }
    //   }
    // }

    // stage('Deploying App to Kubernetes') {
    //   steps {
    //     script {
    //       withKubeConfig([credentialsId: env.KUBERNETES_CREDENTIALS_ID, serverUrl: env.KUBERNETES_SERVER_URL, namespace: env.NAMESPACE]) {
    //         sh "kubectl apply -f ${env.DEPLOYMENT_YAML} -n ${env.NAMESPACE}"
    //       }
    //     }
    //   }
    // }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          withKubeConfig([credentialsId: env.KUBERNETES_CREDENTIALS_ID, serverUrl: env.KUBERNETES_SERVER_URL, namespace: env.NAMESPACE]) {
            kubectlApply file: env.DEPLOYMENT_YAML
          }
        }
      }
    }

    // stage('Remove Unused docker image') {
    //   steps{
    //     script{
    //       sh "$DOCKER_PATH rmi $($DOCKER_PATH images | grep $DOCKER_IMAGE_NAME)"
    //     }
    //   }
    // }

  }

}