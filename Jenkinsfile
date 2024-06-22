pipeline {
    agent any

    environment {
        // Define SonarQube server name as configured in Jenkins
        SONARQUBE_SERVER = 'MySonarQubeServer'
        // Retrieve the SonarQube token securely from Jenkins credentials
        SONARQUBE_TOKEN = credentials('sonartoken')
    }

    tools{
        maven 'Apache Maven 3.6.3'
    }
    
    stages{
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Using SonarQube Scanner for Jenkins
                    def scannerHome = tool 'SonarQube Scanner';
                    withSonarQubeEnv('MySonarQubeServer') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=my_project_key \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=${SONARQUBE_TOKEN}"
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Maven Build') {
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/damienmwene/wordsmith-api.git']])
                sh 'mvn clean install'
            }
        }
        
        stage('Build Docker Image') {
            steps{
                script{
                    sh 'docker build -t mwene/wordsmith-api .'
                }
            }
        }
        
        stage('Push to Dockerhub') {
            steps{
                sh 'docker push mwene/wordsmith-api'
            }
        }
    }
}