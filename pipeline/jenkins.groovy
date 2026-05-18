pipeline {
    agent any // Використовувати агент, де розгорнуто Jenkins [cite: 3, 5]

    parameters {
        // Параметри для вибору ОС та архітектури [cite: 4]
        choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Цільова ОС')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Архітектура процесора')
    }

    environment {
        APP_NAME = 'kbot_my'
        // Твій репозиторій на GitHub
        DOCKER_REPO = 'ghcr.io/kylib4444/kbot_my' 
    }

    stages {
        stage('Clone') {
            steps {
                // Отримання коду з твого репозиторію [cite: 6, 7]
                checkout scm
            }
        }
        stage('Build') {
            steps {
                // Використання обраних параметрів 
                echo "Збірка для ${params.OS} на архітектурі ${params.ARCH}"
                // Тут логіка компіляції (наприклад, через make або go build) [cite: 8]
            }
        }
        stage('Push') {
            steps {
                // Логіка відправки образу в реєстр [cite: 8, 11]
                echo "Пуш образу ${env.DOCKER_REPO}:${params.OS}-${params.ARCH}"
            }
        }
    }
}