pipeline {
    agent {
        label 'workstation'
    }
    options {
        ansiColor('xterm')
    }
    stages {
        stage('Terraform init') {
            steps {
                sh """
                cd 01-vpc
                terraform init -reconfigure
                """
            }
        }
        stage ('terraform plan'){
            steps {
                sh """
                cd 01-vpc
                terraform plan
                """
            }
        }
    }
    post {
        always {
            deleteDir()
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
    }
}
