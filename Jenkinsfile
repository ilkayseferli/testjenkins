pipeline {
    agent any

    environment {
        APP_NAME = "stock-api-app"
        SONAR_SERVER = "SonarQubeServer"
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1"
        
        // KRİTİK: .NET Yolu Tanımı
        DOTNET_ROOT = "/opt/dotnet"
        PATH = "${DOTNET_ROOT}:${HOME}/.dotnet/tools:${env.PATH}"
        
        SONAR_TOKEN = credentials('sonar-token2') 
    }

    stages {
        stage('Step 1: Hazırlık') {
            steps {
                echo "📦 Kodlar GitHub'dan çekiliyor..."
                checkout scm
            }
        }

        stage('Step 2: Testler') {
            steps {
                echo "🧪 Testler koşuluyor..."
                sh "dotnet restore"
                sh "dotnet test StockApi.Tests/StockApi.Tests.csproj --no-restore"
            }
        }

        stage('Step 3: SonarQube Analizi') {
			steps {
				echo "📊 Kod kalitesi ölçülüyor..."
				// Bu blok, Jenkins ayarlarındaki URL'yi ($SONAR_HOST_URL) otomatik enjekte eder
				withSonarQubeEnv("${SONAR_SERVER}") {
					script {
						sh """
							# Scanner'ı başlatırken sistemden gelen URL'yi kullanıyoruz
							dotnet-sonarscanner begin /k:"StockApi" \
								/d:sonar.token="${SONAR_TOKEN}" \
								/d:sonar.host.url="${SONAR_HOST_URL}"
							
							dotnet build StockApi.csproj -c Release
							
							dotnet-sonarscanner end /d:sonar.token="${SONAR_TOKEN}"
						"""
					}
				}
			}
		}

        stage('Step 4: Deploy') {
            steps {
                echo "🚀 Docker ile yayına alınıyor..."
                sh """
                    docker compose build
                    docker compose down
                    docker compose up -d
                """
            }
        }
    }
}