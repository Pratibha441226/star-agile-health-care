pipeline {
  agent any
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from GitHub'
        git branch: 'master', url: 'https://github.com/Pratibha441226/star-agile-health-care.git'
      }
    }
    stage('Create Package') {
      steps {
        echo 'This stage will compile, test, and package my application'
        sh 'mvn clean package -DskipTests'
      }
    }
    /*
    stage('Create Docker Image') {
      steps {
        echo 'This stage will create a Docker image'
        sh 'docker build -t pratibha012/healthcare:1.0 .'
      }
    }
    stage('Login to Dockerhub') {
      steps {
        echo 'This stage will log in to Docker Hub'
        withCredentials([usernamePassword(credentialsId: 'dockercreds', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
          sh 'echo "$dockerpass" | docker login -u "$dockeruser" --password-stdin'
        }
      }
    }
    stage('Docker Push-Image') {
      steps {
        echo 'This stage will push my new image to Docker Hub'
        sh 'docker push pratibha012/healthcare:1.0'
      }
    }  
    */
    stage('AWS Login') {
      steps {
        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awslogin', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          echo 'AWS credentials ready'
        }
      }
    }
    stage('Terraform Apply') {
      steps {
        dir('terraform_files') {
          withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awslogin', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'terraform init'
            sh 'terraform validate'
            sh 'terraform apply --auto-approve'
            sh 'sleep 20'
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        sh 'chmod 600 ./terraform_files/mykey.pem'
        sh '/usr/local/bin/minikube start'
        sh 'sleep 20'
        sh 'scp -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem deployment.yml ubuntu@172.31.13.195:/home/ubuntu/'
        sh 'scp -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem service.yml ubuntu@172.31.13.195:/home/ubuntu/'
        script {
          try {
            sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem ubuntu@172.31.13.195 /usr/local/bin/kubectl apply -f /home/ubuntu/'
          } catch (error) {
            sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/mykey.pem ubuntu@172.31.13.195 /usr/local/bin/kubectl apply -f /home/ubuntu/'
          }
        }
      }
    }
  }
}
