FROM python:3.9-alpine3.13
LABEL maintainer="Peter Francis Robante"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000 

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    /py/bin/pip install django flake8 && \
    rm -rf /tmp && \
    adduser \
         --disabled-password \
         --no-create-home \
         django-user

# Set the PATH and PYTHONPATH environment variables
ENV PATH="/py/bin:$PATH" \
    PYTHONPATH="/py/lib/python3.9/site-packages:$PYTHONPATH"

USER django-user