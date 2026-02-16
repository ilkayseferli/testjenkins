pipeline {
    agent any

    environment {
        // Global Ayarlar
        APP_NAME = "stock-api-app"
        SONAR_SERVER = "SonarQubeServer" // Jenkins Configure System'deki isim
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1" // ICU hatasını önlemek için
		SONAR_TOKEN = credentials('sonar-token2')
    }

    stages {
        stage('Step 1: Hazırlık') {
            steps {
                echo "📦 Kodlar çekiliyor ve sistem kontrol ediliyor..."
                checkout scm
            }
        }

       stage('Step 2: Testleri Koştur') {
			steps {
				echo "🧹 Eski artıklar temizleniyor ve testler başlatılıyor..."
				// Önce her şeyi temizle, sonra testi koştur
				sh "dotnet clean"
				sh "dotnet test StockApi.Tests/StockApi.Tests.csproj --configuration Release"
			}
		}

        stage('Step 3: SonarQube Analizi') {
            steps {
                echo "📊 Kod kalitesi analizi yapılıyor..."
                withSonarQubeEnv("${SONAR_SERVER}") {
                    script {
                        sh """
                        # Scanner yüklü değilse yükle
                        dotnet tool install --global dotnet-sonarscanner || true
                        export PATH="\$PATH:\$HOME/.dotnet/tools"
                        
                        # Analizi Başlat
                        dotnet-sonarscanner begin /k:"StockApi" \
                            /d:sonar.token="${SONAR_TOKEN}" \
                            /d:sonar.host.url="http://sonarqube:9000"
                        
                        # Analiz için Build şart
                        dotnet build StockApi.csproj
                        
                        # Analizi Bitir ve Raporu Gönder
                        dotnet-sonarscanner end /d:sonar.token="${SONAR_TOKEN}"
                        """
                    }
                }
            }
        }

        stage('Step 4: Docker Build & Deploy') {
            steps {
                echo "🚀 Uygulama yayına alınıyor..."
                sh "docker compose build"
                sh "docker compose down"
                sh "docker compose up -d"
            }
        }
    }

    post {
        success {
            echo "✅ Tebrikler Yakli! Uygulama 8085'te, Rapor 9000 portunda yayında! 🚀"
        }
        failure {
            echo "❌ Pipeline durduruldu. Lütfen hataları kontrol et!"
        }
    }
}