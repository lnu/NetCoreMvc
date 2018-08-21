FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 52675
EXPOSE 44319

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY NetCoreMvc.csproj ./
RUN dotnet restore NetCoreMvc.csproj
COPY . .
WORKDIR /src/
RUN dotnet build NetCoreMvc.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish NetCoreMvc.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "NetCoreMvc.dll"]
