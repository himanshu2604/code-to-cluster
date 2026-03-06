pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'himanshunehete/code-to-cluster'
        DOCKER_TAG = 'latest'
        REGISTRY_CREDENTIALS = 'dockerhub-credentials'
        KUBECONFIG            = "C:\\ProgramData\\Jenkins\\.jenkins\\.kube\\config"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/himanshu2604/code-to-cluster.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', REGISTRY_CREDENTIALS) {
                        dockerImage.push("${DOCKER_TAG}")
                        dockerImage.push("build-${BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply deployment and service YAMLs
                    bat 'kubectl apply -f k8s-deployment.yaml'
                    bat 'kubectl apply -f k8s-service.yaml'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                bat 'kubectl rollout status deployment/website-deployment'
                bat 'kubectl get pods'
                bat 'kubectl get svc website-service'
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
