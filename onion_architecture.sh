#!/bin/bash

# Öncelikle kullanıcıdan Solution ve Project Name alalım
read -p "Solution Name: " solutionName
read -p "Project Name: " projectName

# Proje ve solutionu belirlenen dizinde oluşturma
project_dir="C:/Users/abbas/OneDrive/Documents/C#"
solution_dir="$project_dir/$solutionName"
mkdir -p "$solution_dir"
cd "$solution_dir"

# Yeni bir .NET 8 API projesi oluştur
dotnet new sln -n $solutionName

# Core klasörü ve içinde class library oluştur
dotnet new classlib -n $projectName.Application -o Core/$projectName.Application
dotnet new classlib -n $projectName.Domain -o Core/$projectName.Domain

# Infrastructure klasörü ve içinde class library oluştur
dotnet new classlib -n $projectName.Infrastructure -o Infrastructure/$projectName.Infrastructure
dotnet new classlib -n $projectName.Persistence -o Infrastructure/$projectName.Persistence

# Presentation klasörü ve içinde API projesi oluştur
dotnet new webapi -n $projectName.API -o Presentation/$projectName.API

# Solutiona projeleri ekleyelim
dotnet sln add Core/$projectName.Application/$projectName.Application.csproj
dotnet sln add Core/$projectName.Domain/$projectName.Domain.csproj
dotnet sln add Infrastructure/$projectName.Infrastructure/$projectName.Infrastructure.csproj
dotnet sln add Infrastructure/$projectName.Persistence/$projectName.Persistence.csproj
dotnet sln add Presentation/$projectName.API/$projectName.API.csproj

# Domain projesi içinde Entities klasörü oluştur
mkdir -p Core/$projectName.Domain/Entities

# Persistence projesi içinde Concretes ve Contexts klasörleri oluştur
mkdir -p Infrastructure/$projectName.Persistence/Concretes
mkdir -p Infrastructure/$projectName.Persistence/Contexts

# HTTPS yapılandırmasını devre dışı bırak
sed -i 's/https/http/g' Presentation/$projectName.API/Properties/launchSettings.json

# SLN dosyasını çalıştırma
dotnet run --project Presentation/$projectName.API/$projectName.API.csproj

echo "$solutionName solution ve projeler başarıyla $solution_dir dizininde oluşturuldu."
