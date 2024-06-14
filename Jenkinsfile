pipeline {
    agent any
    
    tools {
        maven 'Maven 3.9.7'
        git 'git v2.25.1'
    }
    environment {
        // Define environment variables
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        SONARQUBE_SERVER = 'sonarserver'
        SONARQUBE_TOKEN = credentials('sonartoken')
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git url: 'https://github.com/damienmwene/wordsmith-api.git', branch: 'main'
            }
        }

        stage('Code Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                script {
                    withSonarQubeEnv("${SONARSERVER}") {
                        sh '$SONAR_RUNNER_HOME/opt/sonar-scanner -Dsonar.login=$SONARQUBE_TOKEN'
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
