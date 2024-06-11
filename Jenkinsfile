pipeline {
    agent any
    
    tools {
        maven 'Apache Maven 3.6.3'
        
    environment {
        // Define environment variables
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        SONARQUBE_SERVER = 'SonarQube-Server'
        SONARQUBE_TOKEN = credentials('sonarqube-token-id')
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git url: 'https://github.com/damienmwene/wordsmith-api.git', branch: 'main'
            }
        }

        stage('Code Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube-Server') {
                        sh "mvn sonar:sonar -Dsonar.login=${SONARQUBE_TOKEN}"
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qualityGate = waitForQualityGate()
                        if (qualityGate.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("mwene/wordsmith-api:${env.BUILD_ID}")
                    dockerImage.push()
                    dockerImage.push('latest')
                }
            }
        }
    }
}
