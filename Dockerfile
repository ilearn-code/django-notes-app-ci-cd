# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app/backend

# Copy requirements.txt first to leverage Docker cache for dependencies
COPY requirements.txt /app/backend/

# Install system dependencies and Python packages in a single RUN statement
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gcc default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir -r requirements.txt

# Install the mysqlclient separately to avoid issues with cached layers
RUN pip install mysqlclient

# Copy the rest of the application code into the container
COPY . /app/backend/

# Expose the port the app runs on
EXPOSE 8000

# (Optional) Run migrations as part of the Docker build (or you can handle this at runtime)
# RUN python manage.py makemigrations && python manage.py migrate

# (Optional) Set an entrypoint or CMD for your app (if you're running Django)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
