pipeline {
    agent any

    tools {
        maven 'maven'
        // Removed jdk 'jdk17' because it's not configured in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/UmaMalagund-arch/JOB_PORTAL.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    pkill -f JOB_PORTAL.jar || true
                    nohup java -jar target/*.jar > app.log 2>&1 &
                '''
            }
        }
    }
}
