pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        DOCKERHUB_USERNAME = "poojithab154"
    }
    stages {
        stage("clean") {
            steps {
                sh 'mvn clean'
            }
        }
        stage("validate") {
            steps {
                sh 'mvn validate'
            }
        }
        stage("test") {
            steps {
                sh 'mvn test'
            }
        }
        stage("package") {
            steps {
                sh 'mvn package'
            }
            post {
                success {
                    echo "build successful"
                }
            }
        }
        stage("build docker image") {
            steps {
                sh 'docker build -t property .'
            }
            post {
                success {
                    echo "image built successfully"
                }
                failure {
                    echo "image not built"
                }
            }
        }
        stage("push to docker hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker tag netflix ${DOCKERHUB_USERNAME}/property
                    docker push ${DOCKERHUB_USERNAME}/property
                    """
                }
            }
        }
        stage("remove docker image locally") {
            steps {
                sh """
                docker rmi -f ${DOCKERHUB_USERNAME}/property || true
                docker rmi -f property || true
                """
            }
        }
        stage("stop and restart") {
            steps {
                sh """
                docker rm -f app || true
                docker run -it -d --name app -p 8081:8080 ${DOCKERHUB_USERNAME}/property
                """
            }
        }
    }
    post {
        success {
            echo "deployment successful"
        }
        failure {
            echo "deployment failed"
        }
    }
}
