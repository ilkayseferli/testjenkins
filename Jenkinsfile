pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "stock-api-app"
    }

    stages {
        stage('Step 1: Kodları Çek') {
            steps {
                checkout scm
            }
        }

        stage('Step 2: Docker Imajını Yap') {
            steps {
                sh "docker compose build"
            }
        }

        stage('Step 3: Eski Sistemi Sil ve Yeniyi Başlat') {
            steps {
                sh "docker compose down" // Varsa eskiyi durdurur
                sh "docker compose up -d" // Yeni versiyonu arkada başlatır
            }
        }
        
        stage('Step 4: Durum Kontrolü') {
            steps {
                sh "docker ps | grep stock-api-container"
            }
        }
    }

    post {
        success { echo "Sistem 8085 portunda tıkır tıkır çalışıyor Yakli! 🚀" }
        failure { echo "Bir hata oldu, logları incele. ❌" }
    }
}