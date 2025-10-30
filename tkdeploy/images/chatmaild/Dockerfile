# syntax=docker/dockerfile:1

# TODO: build chatmaild virtualenv image with entrypoints for each service.
FROM python:3.12-slim

WORKDIR /opt/chatmaild

COPY requirements.txt ./

RUN pip install --upgrade pip && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# Copy source tree during final implementation; placeholder for now.

CMD ["chatmaild", "--help"]
