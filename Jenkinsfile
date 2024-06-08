pipeline {
    agent any

    environment {
        // Define Docker Hub credentials (You need to configure these credentials in Jenkins)
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credential-id')
        DOCKERHUB_REPO = 'mwene/wordsmith-api'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your version control system
                git 'https://github.com/damienmwene/wordsmith-api.git'
            }
        }
        
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'my_sonar_scanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=your_project_key -Dsonar.sources=."
                }
            }
        

            post {
                success {
                    echo 'Analysis completed successfully'
                }
                failure {
                    echo 'Analysis failed'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    def app = docker.build("${DOCKERHUB_REPO}:${env.BUILD_NUMBER}")
                }
            }

            post {
                success {
                    echo 'Docker image built and pushed successfully.'
                }
                failure {
                    echo 'Build or push failed.'
                }
            }

        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credential-id') (
                        def app = docker.build("${DOCKERHUB_REPO}:${env.BUILD_NUMBER}")
                        app.push()
                    )
                }
            }
        }

        stage ('Email Notifications') {
            success {
                emailext(
                    subject: "Jenkins Job Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: "Good news! The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} was successful. Check the details at ${env.BUILD_URL}",
                    recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
            }
            
            failure {
                emailext(
                    subject: "Jenkins Job Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: "Unfortunately, the Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} has failed. Check the details at ${env.BUILD_URL}",
                    recipientProviders: [[$class: 'DevelopersRecipientProvider']]
                )
            }
        }

    }

}