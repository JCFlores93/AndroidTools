pipeline {
    parameters{
        string defaultValue: "git@github.com:JCFlores93/AndroidTools.git",
                description: "Repository",
                name: 'REPO'
        string defaultValue: "master",
                description: "Branch of repository",
                name: 'BRANCH'
        booleanParam defaultValue: true,
                description: "Deploy to dockerHub",
                name: 'DEPLOY'
    }
    environment {
        // registry = "nogala/androidtest"
        registry = "jeanflores2c/androidtest"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    // agent {
    //     label 'automation_node'
    // }
    agent any
    stages {
        stage('Cloning Git') {
            steps {
                git url: params.REPO , branch: params.BRANCH
            }
        }
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy Image') {
            steps{
                script {
                    if(params.DEPLOY) {
                        docker.withRegistry('', registryCredential) {
                            dockerImage.push()
                        }
                    }
                    else {
                        echo "Not deploy"
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
