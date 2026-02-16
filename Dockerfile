# 1. Aşama: Build (SDK)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Sadece ana proje dosyasını çek ve restore et
COPY ["StockApi.csproj", "./"]
RUN dotnet restore

# Tüm kodları kopyala
COPY . .

# SADECE ana projeyi yayınla (Testlerin karışmasını önler)
RUN dotnet publish "StockApi.csproj" -c Release -o /app/publish

# 2. Aşama: Runtime (ASP.NET)
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .

# .NET'in ICU kütüphanesi hatası vermemesi için Invariant Mode (2026 Standartı)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

ENTRYPOINT ["dotnet", "StockApi.dll"]