// // pipeline {
// //     agent {
// //         label 'workstation'
// //     }
// //     options {
// //         disableConcurrentBuilds()
// //         ansiColor('xterm')
// //     }
// //     stages {
// //         stage('Terraform init') {
// //             steps {
// //                 sh """
// //                 cd 01-vpc
// //                 terraform init -reconfigure
// //                 """
// //             }
// //         }
// //         stage ('terraform plan'){
// //             steps {
// //                 sh """
// //                 cd 01-vpc
// //                 terraform plan
// //                 """
// //             }
// //         }
// //     }
// //         stage ('Terraform apply') {
// //             input {
// //                 message "Should we continue?"
// //                 ok "Yes, we should."
// //             }
// //             steps {
// //                 sh """
// //                 cd 01-vpc
// //                 terraform apply -auto-approve
// //                 """
// //             }
// //         }
// //     post {
// //         always {  // delete the workspace in a Jenkins Pipeline  && Safely delete the contents of 'workspace' and 'jobs' in Jenkins
// //             deleteDir()
// //         }
// //         failure {
// //             echo 'Pipeline failed. Please check the logs for more details.'
// //         }
// //         success {
// //             echo 'Pipeline completed successfully!'
// //         }
// //     }
// // }


// pipeline {
//     agent {
//         label 'workstation'
//     }
//     options {
//         disableConcurrentBuilds()
//         ansiColor('xterm')
//     }
//     stages {
//         stage('Terraform init') {
//             steps {
//                 sh '''
//                 cd 01-vpc
//                 terraform init -reconfigure
//                 '''
//             }
//         }
//         stage('Terraform plan') {
//             steps {
//                 sh '''
//                 cd 01-vpc
//                 terraform plan
//                 '''
//             }
//         }
//         stage('Terraform apply') {
//             input {
//                 message "Should we continue?"
//                 ok "Yes, we should."
//             }
//             steps {
//                 sh '''
//                 cd 01-vpc
//                 terraform apply -auto-approve
//                 '''
//             }
//         }
//     }
//     post {
//         always {
//             deleteDir()  // Deletes the workspace directory after build
//         }
//         failure {
//             echo 'Pipeline failed. Please check the logs for more details.'
//         }
//         success {
//             echo 'Pipeline completed successfully!'
//         }
//     }
// }