# BUILD
FROM python:3.10-slim-buster as builder

# Set the working directory
WORKDIR /web

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies including uwsgi
RUN apt-get update
RUN apt-get install -y --no-install-recommends
RUN apt-get -y install gcc postgresql
# RUN apt-get purge -y --auto-remove build-essential python3-dev libpcre3-dev
# RUN apt-get clean


# Copy the requirements file
RUN pip install --upgrade pip
COPY requirements.txt .
# RUN pip install -I -r requirements.txt --no-cache-dir
# RUN rm -rf /var/lib/apt/lists/*
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /web/wheels -r requirements.txt

# COPY . .

# FINAL
FROM python:3.10-slim-buster as prod
# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN addgroup --system app && adduser --system --group app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends
COPY --from=builder /web/wheels /wheels
COPY --from=builder /web/requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*


# copy project
COPY . $APP_HOME
# chown all the files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

RUN python manage.py collectstatic --no-input
# VOLUME ["/web/staticfiles"]
