# 1. Aşama: Derleme (Build)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# Proje dosyasını kopyala ve kütüphaneleri indir
COPY ["StockApi.csproj", "./"]
RUN dotnet restore

# Tüm kodları kopyala ve projeyi yayınla (publish)
COPY . .
RUN dotnet publish -c Release -o /app/publish

# 2. Aşama: Çalıştırma (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .
# Uygulamanın çalışacağı komut
ENTRYPOINT ["dotnet", "StockApi.dll"]