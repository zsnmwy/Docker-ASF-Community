FROM mcr.microsoft.com/dotnet/core/runtime:2.1-alpine

LABEL maintainer="zsnmwy szlszl35622@gmail.com"

WORKDIR /app

COPY Caddyfile /app/caddy/

COPY start.sh /app

COPY openssl /app/openssl


RUN apk add --no-cache openssl p7zip wget curl expect bash ca-certificates libc6-compat libunwind-dev  libcurl icu-libs krb5-libs lttng-ust-dev  openssl-dev zlib && \
    wget $(curl -s "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/releases/latest"  | awk -F '"' '/browser_download_url/{print $4}' | grep linux-x64) && \
    7za x ASF-linux-x64.zip && \
    rm -rf ASF-linux-x64.zip && \
    curl https://getcaddy.com | bash -s personal hook.service && \
    caddy -service install -agree -conf /app/caddy/Caddyfile && \
    chmod a+x /app/start.sh && \
    chmod a+x /app/ArchiSteamFarm

ENTRYPOINT [ "/app/start.sh" ]