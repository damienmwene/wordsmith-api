pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credential-id')
        SONARQUBE_SERVER = 'my_sonar_scanner' // This should match the name of your SonarQube server configuration in Jenkins
        DOCKER_IMAGE = 'your-dockerhub-username/your-image-name'
    }

    stages {
        stage('SCM Checkout') {
            steps {
                git 'https://github.com/damienmwene/wordsmith-api.git'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarQube Scanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=your_project_key -Dsonar.sources=."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(env.DOCKER_IMAGE)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credential-id') (
                        docker.image(env.DOCKER_IMAGE).push()
                    )
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "Jenkins Job Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                Good news! The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} was successful.
                
                - SonarQube Analysis: SUCCESS
                - Docker Image: ${env.DOCKER_IMAGE} built and pushed successfully.

                Check the details at ${env.BUILD_URL}
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
        failure {
            emailext(
                subject: "Jenkins Job Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                Unfortunately, the Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} has failed.
                
                Check the details at ${env.BUILD_URL}
                """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}