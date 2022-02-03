# syntax=docker/dockerfile:1

FROM python:3 AS builder
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/

RUN django-admin startproject composeexample .

FROM scratch AS export-stage

COPY --from=builder ./code/ .