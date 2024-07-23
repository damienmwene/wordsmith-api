pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'
        SONARQUBE_TOKEN = credentials('sonartoken')
    }

    tools{
        maven 'Apache Maven 3.9.8'
    }
    
    stages{
        stage('Maven Build') {
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/damienmwene/wordsmith-api.git']])
                sh 'mvn clean install'
            }
        }
        
        stage('Build Docker Image') {
            steps{
                script{
                    sh 'docker build -t mwene/wordsmith-api:latest .'
                }
            }
        }
        
        stage('Push to Dockerhub') {
            steps{
                sh 'docker push mwene/wordsmith-api:latest'
            }
        }
    }
}