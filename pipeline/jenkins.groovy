pipeline {
    agent any 

    parameters {        
        choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Цільова ОС')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Архітектура процесора')
    }

    environment {
        APP_NAME = 'kbot_my'
        DOCKER_REPO = 'ghcr.io/kylib4444/kbot_my' 
    }

    stages {
        stage('Clone') {
            steps {                
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo "Збірка для ${params.OS} на архітектурі ${params.ARCH}"
            }
        }
        stage('Push') {
            steps {
                echo "Пуш образу ${env.DOCKER_REPO}:${params.OS}-${params.ARCH}"
            }
        }
    }
}