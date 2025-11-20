pipeline {
    agent any

    tools {
        maven 'maven'
    }

    stages {

        stage('Build WAR') {
            steps {
                echo "📦 Building Job-Portal project..."
                sh 'mvn clean package -DskipTests'
            }
            post {
                success { echo '✔ WAR build successful.' }
                failure { echo '❌ WAR build failed.' }
            }
        }

        stage('Docker Build Image') {
            steps {
                echo "🐳 Building Docker image for Job-Portal..."
                sh 'sudo docker build -t jobportal-cicd .'
            }
            post {
                success { echo '✔ Docker image created.' }
                failure { echo '❌ Docker build failed.' }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-cred-id',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo "$PASS" | sudo docker login -u "$USER" --password-stdin
                    '''
                }
            }
        }

        stage('Docker Tag Image') {
            steps {
                echo "🏷 Tagging image..."
                sh 'sudo docker tag jobportal-cicd umamalagund9620/jobportal-cicd:latest'
            }
            post {
                success { echo '✔ Image tagged.' }
                failure { echo '❌ Failed to tag image.' }
            }
        }

        stage('Docker Push Image') {
            steps {
                echo "📤 Pushing image to DockerHub..."
                sh 'sudo docker push umamalagund9620/jobportal-cicd:latest'
            }
            post {
                success { echo '✔ Image pushed to DockerHub.' }
                failure { echo '❌ Failed to push image.' }
            }
        }

        stage('Cleanup Local Images') {
            steps {
                echo "🧹 Cleaning up local Docker images..."
                sh '''
                    sudo docker rmi umamalagund9620/jobportal-cicd:latest || true
                    sudo docker rmi jobportal-cicd || true
                '''
            }
            post {
                success { echo '✔ Cleanup done.' }
                failure { echo '❌ Cleanup failed.' }
            }
        }

        stage('Docker Logout') {
            steps {
                echo "🔒 Logging out from DockerHub..."
                sh 'sudo docker logout'
            }
        }

        stage('Deploy Container') {
            steps {
                script {

                    echo "🔍 Checking if 'jobportal-container' already exists..."

                    def containerExists = sh(
                        script: "sudo docker ps -a --format '{{.Names}}' | grep -w jobportal-container || true",
                        returnStdout: true
                    ).trim()

                    if (containerExists) {
                        echo "⚠️ Container already exists."

                        def userChoice = input(
                            id: 'ContainerRestart',
                            message: 'Container exists. Redeploy?',
                            parameters: [choice(choices: ['Yes', 'No'], description: 'Restart container?', name: 'Confirm')]
                        )

                        if (userChoice == 'Yes') {
                            echo "🛑 Stopping old container..."
                            sh '''
                                sudo docker stop jobportal-container || true
                                sudo docker rm jobportal-container || true

                                echo "🚀 Starting new container..."
                                sudo docker run -d -p 8084:8080 --name jobportal-container umamalagund9620/jobportal-cicd:latest
                            '''
                        } else {
                            echo "⏩ Skipping redeploy."
                        }

                    } else {

                        echo "🚀 No container found — starting new one..."
                        sh '''
                            sudo docker run -d -p 8084:8080 --name jobportal-container umamalagund9620/jobportal-cicd:latest
                        '''
                    }
                }
            }
        }

        stage('Done') {
            steps {
                echo "🎉 Pipeline completed!"
            }
        }
    }

    post {
        always { echo '📌 Pipeline finished executing.' }
        success { echo '✅ Pipeline succeeded.' }
        failure { echo '❌ Pipeline failed.' }
    }
}
