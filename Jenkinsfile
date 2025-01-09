pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:$PATH"
        TF_WORKSPACE = 'dev'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'terraform_jenkins', url: 'https://github.com/SergeAbroyan/terraform.git'
            }
        }
        stage('Select Terraform Workspace') {
            steps {
                dir('.') {
                    sh '''
                        unset TF_WORKSPACE
                        terraform workspace select dev || terraform workspace new dev
                    '''
                }
            }
        }
        stage('Terraform Init') {
            steps {
                dir('.') {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY'), 
                                 string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_KEY')]) {
                    dir('.') {
                        sh '''
                            terraform plan \
                            -var="aws_access_key=${AWS_ACCESS_KEY}" \
                            -var="aws_secret_key=${AWS_SECRET_KEY}"
                        '''
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY'), 
                                 string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_KEY')]) {
                    dir('.') {
                        sh '''
                            terraform apply -auto-approve \
                            -var="aws_access_key=${AWS_ACCESS_KEY}" \
                            -var="aws_secret_key=${AWS_SECRET_KEY}"
                        '''
                    }
                }
            }
        }
        stage('Archive Terraform State') {
            steps {
                dir('.') {
                    sh '''
                        # Ensure workspace-specific state file is copied
                        cp terraform.tfstate.d/dev/terraform.tfstate terraform.tfstate
                    '''
                    archiveArtifacts artifacts: 'terraform.tfstate', allowEmptyArchive: false
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Terraform plan and apply completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
