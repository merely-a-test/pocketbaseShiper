FROM alpine:latest
ARG PB_VERSION=0.39.4

RUN apk add --no-cache unzip ca-certificates

# Descargar e instalar PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Crear la carpeta de datos por defecto
RUN mkdir -p /pb/pb_data

EXPOSE 8080

# Iniciar PocketBase enlazando el puerto expuesto
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
