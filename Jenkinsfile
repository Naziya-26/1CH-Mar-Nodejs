pipeline {
    agent any

   parameters {
    string(name: 'CodeCommitURL', defaultValue: "https://github.com/Naziya-26/1CH-Mar-Nodejs.git", description: 'URL of the CodeCommit repository')
    string(name: 'ECRAccountID', defaultValue: "630787644279", description: 'AWS ECR Account ID')
    string(name: 'ECRRepository', defaultValue: "app", description: 'Name of the ECR repository')
    string(name: 'ECRRegion', defaultValue: "us-west-1", description: 'AWS region where ECR is located')
    string(name: 'ECRAccessKey', defaultValue: "AKIAZFXO7TN36MRKKZ4A", description: 'AWS access key for ECR')
    string(name: 'ECRSecretKey', defaultValue: "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", description: 'AWS secret key for ECR')
    string(name: 'SSHUsername', defaultValue: "1CHAdministrator", description: 'Username for SSH connection to EC2')
    string(name: 'SSHPassword', defaultValue: "admin", description: 'Password for SSH connection to EC2')
    string(name: 'EC2IP', defaultValue: "54.183.18.69", description: 'IP address of the EC2 instance')
    string(name: 'KubernetesDeploymentFile', defaultValue: "naziya/deployment.yaml", description: 'Path to the Kubernetes deployment file')
}

    stages {
        
        stage('Checkout') {
            steps {
                git credentialsId: 'NazCodecommit', url: "$(params.CodeCommitURL)"
            }
        }
        
        stage('Clone GitHub Repository') {
            steps {
                sh "'git clone https://github.com/1CloudHub/1CH-Mar-Nodejs.git'"
            }
        }
        
        stage('Set up Git credentials for CodeCommit') {
            steps {
                sh '''
                    git config --global credential.helper '!aws codecommit credential-helper $@'
                    git config --global credential.UseHttpPath true
                '''
            }
        }
        
        stage('Clone to CodeCommit') {
            steps {
                sh '''
                    cd 1CH-Mar-Nodejs # Specify the directory where the repository was cloned
                    git remote add codecommit ${params.CodeCommitURL}
                    git push codecommit --all
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh 'docker build -t naz .'
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${params.ECRRegion} | docker login --username AWS --password-stdin ${params.ECRAccountID}.dkr.ecr.${params.ECRRegion}.amazonaws.com/${params.ECRRepository}"
                    sh "docker tag image1 ${params.ECRAccountID}.dkr.ecr.${params.ECRRegion}.amazonaws.com/${params.ECRRepository}:latest"
                    sh "docker push ${params.ECRAccountID}.dkr.ecr.${params.ECRRegion}.amazonaws.com/${params.ECRRepository}:latest"
                }
            }
        }
        
        stage('SSH to EC2') {



            steps {



                script {



                    sshagent(credentials: ['1CHAdministrator']) {



                        



                    sh """



                        sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo minikube status'



                        sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'AWS_ACCESS_KEY_ID=AKIAZFXO7TN36MRKKZ4A AWS_SECRET_ACCESS_KEY=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 aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin  631847701427.dkr.ecr.us-west-1.amazonaws.com'



                        sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo kubectl create secret docker-registry my-registry --docker-server=${params.DOCKER_SERVER} --docker-username=${params.DOCKER_NAME} --docker-password=${params.DOCKER_PASSWD}'



                        sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo kubectl apply -f 1CH-Mar-Nodejs/deployment.yaml'



                        sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo kubectl get pods'



                    """



                    }



                }



            }



        }



       



         stage('Expose pod on container') {



            steps {



                script {



                    sh """



                       sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo kubectl expose deployment my-nodejs-app --name=my-nodejs-app-svc1 --type=NodePort --port=8080'



                    """ 



                }       



            }            



        }               



         stage('Port-Forward Stage') {



            steps {



                script {



                    try{



                        sh """



                            sshpass -p '${params.SSHPASSWORD}' ssh -p 50022 -o "StrictHostKeyChecking=no" ${params.SSHUSERNAME}@${params.EC2IP} 'sudo kubectl port-forward --address 0.0.0.0 service/my-nodejs-app-svc 8080:8080 > /dev/null 2>&1 &'



                        """



                        



                    }



                    catch(Exception e){



                        echo 'Success'



                    }



                }



            }



        }



        



    }



}        
