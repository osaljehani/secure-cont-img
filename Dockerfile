FROM debian:12-slim

ARG COMMIT_AUTHOR
LABEL maintainer=${COMMIT_AUTHOR}
LABEL org.opencontainers.image.authors=${COMMIT_AUTHOR}

ENV DEBIAN_FRONTEND=noninteractive

# Minimal runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata \
        python3-minimal \
        passwd \
        util-linux \
    && rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -u 10001 appuser

# Lock root & remove sudo/su
RUN set -eux; \
    passwd -l root; \
    usermod -s /usr/sbin/nologin root; \
    apt-get update && apt-get purge -y sudo || true; \
    if command -v su >/dev/null 2>&1; then rm -f "$(command -v su)"; fi; \
    rm -rf /var/lib/apt/lists/*

# Remove setuid bits
RUN find / -xdev -type f -perm -4000 -exec chmod u-s {} + 2>/dev/null || true

WORKDIR /app
COPY server.py /app/server.py

USER appuser
ENV PORT=8080
EXPOSE 8080
CMD ["python3", "-u", "/app/server.py"]
