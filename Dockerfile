# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set environment variables to prevent Python from writing pyc files and buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install dependencies including Xvfb and other required packages
RUN apt-get update && \
    apt-get install -y wget gnupg unzip curl xvfb && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* && \
    google-chrome --version  # Verify Chrome installation

# Install ChromeDriver using the provided URL
RUN wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/129.0.6668.58/linux64/chromedriver-linux64.zip && \
    unzip /tmp/chromedriver.zip -d /tmp/ && \
    mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Install Robot Framework, SeleniumLibrary, and XvfbRobot
RUN pip install --no-cache-dir robotframework robotframework-seleniumlibrary robotframework-xvfb

# Create a directory for tests
WORKDIR /tests

# Copy your test files into the container
COPY ./tests /tests

RUN Xvfb :10 -ac &
ENV DISPLAY=:10

# Command to run tests
CMD ["robot", "--outputdir", "/tests/reports", "/tests/sample_run.robot"]
