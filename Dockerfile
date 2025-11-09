FROM nginx:alpine

# Metadatos
ARG ENVIRONMENT
ARG DATE
ARG MESSAGE
ARG REPO

ENV ENVIRONMENT=${ENVIRONMENT}

LABEL org.opencontainers.image.title="kanbista-multi-entorno" \
      org.opencontainers.image.description=${MESSAGE} \
      org.opencontainers.image.created=${DATE} \
      org.opencontainers.image.source=${REPO}

# Copiamos el HTML compilado
COPY build/index.html /usr/share/nginx/html/index.html

# Exponer puerto
EXPOSE 80
