pipeline {
    agent any

    tools{
        maven 'maven_3_9_7'
    }
    
    stages{
        stage('Maven Build'){
            steps{
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/damienmwene/wordsmith-api.git']])
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps{
                def mvn = tool 'maven_3_9_7';
                withSonarQubeEnv() {
                sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=api-code-analysis -Dsonar.projectName='api-code-analysis'"
                }
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