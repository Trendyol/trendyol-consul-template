FROM alpine
ARG VCS_REF
ARG BUILD_TIME
ARG VERSION

LABEL org.opencontainers.image.authors="trendyoltech" \
org.opencontainers.image.version=$VERSION \
org.opencontainers.image.title="Trendyol Consul Template Image" \
org.opencontainers.image.description="This image is wrapper of consul-template" \
org.opencontainers.image.vendor="Trendyol" \
org.opencontainers.image.revision=$VCS_REF \
org.opencontainers.image.created=$BUILD_TIME \
org.opencontainers.image.source="https://github.com/Trendyol/trendyol-consul-template"


ENV LOGGING_LEVEL=debug
ENV PACKAGE_VERSION=0.24.1
ENV PACKAGE_DIST=linux
ENV PACKAGE_ARCH=amd64
ENV DOWNLOAD_URL=https://releases.hashicorp.com/consul-template/${PACKAGE_VERSION}/consul-template_${PACKAGE_VERSION}_${PACKAGE_DIST}_${PACKAGE_ARCH}.tgz

ENV CONSUL_TEMPLATE_PROCESS_FLAGS ""
ENV CONSUL_TEMPLATE_TEMPLATE_PATH ""
ENV CONSUL_TEMPLATE_OUTPUT_PATH ""
ENV CONSUL_ADDR ""

RUN apk add tar && \
apk add wget && \
wget -q -O- $DOWNLOAD_URL | tar xvz && \
mv consul-template /usr/local/bin

ENTRYPOINT ["./entrypoint.sh"]

COPY entrypoint.sh entrypoint.sh