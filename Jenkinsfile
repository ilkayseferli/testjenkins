pipeline {
    agent any

    environment {
        APP_NAME = "stock-api-app"
        SONAR_SERVER = "SonarQubeServer"
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1"
        
        // .NET'in kurulu olduğu ana dizin
        DOTNET_ROOT = "/opt/dotnet"
        // PATH'e hem .NET'i hem de Scanner araçlarını ekliyoruz
        PATH = "${DOTNET_ROOT}:${HOME}/.dotnet/tools:${env.PATH}"
        
        // Jenkins Credentials ID'nin 'sonar-token2' olduğundan emin ol!
        SONAR_TOKEN = credentials('sonar-token2') 
    }

    stages {
        stage('Step 1: Hazırlık') {
            steps {
                echo "📦 Kodlar çekiliyor..."
                checkout scm
            }
        }

        stage('Step 2: Testleri Koştur') {
            steps {
                echo "🧪 Testler başlatılıyor..."
                sh """
                    dotnet restore
                    dotnet test StockApi.Tests/StockApi.Tests.csproj --no-restore
                """
            }
        }

        stage('Step 3: SonarQube Analizi') {
            steps {
                echo "📊 SonarQube taraması yapılıyor..."
                withSonarQubeEnv("${SONAR_SERVER}") {
                    script {
                        // 'sh' içinde değişkenlerin kaybolmaması için tek blokta yazıyoruz
                        sh """
                            # Scanner yüklü mü bak, yoksa kur
                            dotnet tool install --global dotnet-sonarscanner || true
                            
                            # Analizi Başlat
                            dotnet-sonarscanner begin /k:"StockApi" \
                                /d:sonar.token="${SONAR_TOKEN}" \
                                /d:sonar.host.url="http://sonarqube:9000"
                            
                            # Analiz için Build şart (Release modunda yapmak daha iyidir)
                            dotnet build StockApi.csproj -c Release
                            
                            # Analizi Bitir ve Gönder
                            dotnet-sonarscanner end /d:sonar.token="${SONAR_TOKEN}"
                        """
                    }
                }
            }
        }

        stage('Step 4: Docker Build & Deploy') {
            steps {
                echo "🐳 Docker işlemleri başlatılıyor..."
                sh """
                    docker compose build
                    docker compose down
                    docker compose up -d
                """
            }
        }
    }

    post {
        success {
            echo "✅ Mükemmel Yakli! Her şey yeşil. 🚀"
        }
        failure {
            echo "❌ Bir hata oluştu, logları kontrol et Yakli!"
        }
    }
}