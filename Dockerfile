FROM mcr.microsoft.com/dotnet/core/runtime:3.0-alpine-arm64v8
WORKDIR /app
COPY Caddyfile /app/caddy/
COPY start.sh /app
COPY openssl /app/openssl
RUN apk add --no-cache curl expect p7zip bash openssl ca-certificates libcurl icu-libs krb5-libs ??? lttng-ust zlib && \
    wget $(curl -s https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases/latest | awk -F '"' '/browser_download_url/{print $4}' | grep generic.zip) && \
    7za x ASF*.zip && rm ASF*.zip && \
    sed -i 's/netcoreapp2.2/netcoreapp3.0/' ArchiSteamFarm.runtimeconfig.json && \
    sed -i 's/2.2.4/3.0.0-preview6-27804-01/' ArchiSteamFarm.runtimeconfig.json && \
    curl https://getcaddy.com | bash -s personal hook.service && \
    caddy -service install -agree -conf /app/caddy/Caddyfile && \
    apk del p7zip curl
ENTRYPOINT ["/app/start.sh"]