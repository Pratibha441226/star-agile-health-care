pipeline {
  agent any
     
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'master', url: 'https://github.com/Pratibha441226/star-agile-health-care.git'
                        }
            }
    stage('Create Package') {
      steps {
        echo 'This stage will compile, test, package my application'
        sh 'mvn package'
                          }
            }
    
     stage('Create Docker Image') {
      steps {
        echo 'This stage will Create a Docker image'
        sh 'docker build -t pratibha012/healthcare:1.0 .'
                          }
            }
     stage('Login to Dockerhub') {
      steps {
        echo 'This stage will loginto Dockerhub' 
        withCredentials([usernamePassword(credentialsId: 'dockercreds', passwordVariable: 'dockerpassword', usernameVariable: 'dockerlogin')]) {
        sh 'docker login -u ${dockeruser} -p ${dockerpass}'
            }
         }
     }
    stage('Docker Push-Image') {
      steps {
        echo 'This stage will push my new image to the dockerhub'
        sh 'docker push pratibha012/healthcare:1.0'
            }
      }
    stage('AWS-Login') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
         }
      }
    }
    stage('setting the Kubernetes Cluster') {
      steps {
        dir('terraform_files'){
          sh 'terraform init'
          sh 'terraform validate'
          sh 'terraform apply --auto-approve'
          sh 'sleep 20'
        }
      }
    } 
    stage('deploy kubernetes')
    steps{
      sh 'sudo chmod 600 ./terraform_files/mykey.pem'
      sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem deployment.yml ubuntu@172.31.30.101:/home/ubuntu/'
      sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem service.yml ubuntu@172.31.30.101:/home/ubuntu/'
    script{
      try{
        sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem ubuntu@172.31.30.101 kubectl apply -f .'
      }catch(error)
      {
        sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem ubuntu@172.31.30.101 kubectl apply -f .'
      }
    }
    }   
  }
}

 
