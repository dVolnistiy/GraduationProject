# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9.5-slim-buster

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install --upgrade wheel setuptools \
    && pip install -r requirements.txt 

WORKDIR /app
COPY app.py database.py user.py /app/

CMD ["python", "app.py"]
