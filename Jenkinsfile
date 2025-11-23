pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'jdk17'
    }

    environment {
        APP_NAME = "jobportal"
        BRANCH = "main"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling source code..."
                git branch: "main", url: "https://github.com/UmaMalagund-arch/JOB_PORTAL.git"
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: "target/*.jar", fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Spring Boot JAR..."

                sh '''
                    pkill -f ${APP_NAME}.jar || true
                    
                    nohup java -jar target/*.jar > app.log 2>&1 &
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment Successful!"
        }
        failure {
            echo "❌ Build Failed. Check Jenkins logs."
        }
    }
}
