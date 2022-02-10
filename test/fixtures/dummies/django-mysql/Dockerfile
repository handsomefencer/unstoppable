# syntax=docker/dockerfile:1

FROM python:3.10.1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# establish the working directory 
WORKDIR /code

# copy and install requirements.txt to speed up caching:
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .