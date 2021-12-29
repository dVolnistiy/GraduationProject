pipeline{
    agent any
    stages{
        stage('Git'){
            steps{
                git branch: 'main', credentialsId: 'MyGitHub', 
                   url: 'https://github.com/dVolnistiy/GraduationProject'
                   sh 'whoami'
            }
        }
        
        stage('Docker login'){
             steps{
                withCredentials([string(credentialsId: 'DockerHubPasswd', variable: 'password')]) {
                    sh 'docker login -u dvolnistiy -p ${password}'
                }
            }
        }
        
        stage('Add secure information to directory') {
            steps{
                withCredentials([string(credentialsId: 'vault_pass.txt', variable: 'vault')]) {
                    sh 'echo ${vault} > vault_pass.txt '
                }
                withCredentials([string(credentialsId: 'DBPass', variable: 'dbpass')]) {
                    sh 'echo ${dbpass} > .auto.tfvars'
                }
            }
        }
        stage('Infrastructure deployment'){
            steps{
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                    credentialsId: 'AWS'
                ]]) {
                    sh 'make init; make plan; make create'
                }

            }
        }
        
    }   
}