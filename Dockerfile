FROM alpine:latest
ARG PB_VERSION=0.39.4

RUN apk add --no-cache unzip ca-certificates curl

# Detectar arquitectura y descargar el binario correcto de PocketBase
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        PB_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        PB_ARCH="arm64"; \
    elif [ "$ARCH" = "armv7l" ]; then \
        PB_ARCH="armv7"; \
    else \
        PB_ARCH="amd64"; \
    fi && \
    curl -L -o /tmp/pb.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${PB_ARCH}.zip" && \
    mkdir -p /pb && \
    unzip /tmp/pb.zip -d /pb/ && \
    rm /tmp/pb.zip

# Definir el directorio de trabajo
WORKDIR /app

# Copiar el código del repositorio (incluyendo pb_public) al contenedor
COPY . /app

# Crear y asegurar permisos para la carpeta de datos y la app
RUN mkdir -p /app/pb_data && chmod -R 777 /pb && chmod -R 777 /app

EXPOSE 8080

# Iniciar PocketBase enlazando al puerto dinámico y especificando directorios
CMD ["sh", "-c", "/pb/pocketbase serve --http=0.0.0.0:${PORT:-8080} --dir=/app/pb_data --publicDir=/app/pb_public"]
