# ------------------------------------------------------------
# Build stage
# ------------------------------------------------------------

FROM python:3.12-slim AS builder

WORKDIR /build

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev

COPY src ./src

# ------------------------------------------------------------
# Runtime image
# ------------------------------------------------------------

FROM python:3.12-slim AS runtime

WORKDIR /app

COPY --from=builder /build /app

ENV PATH="/app/.venv/bin:$PATH"

# Headless G-Shock server
CMD ["python", "src/gshock-server/gshock_server.py"]
