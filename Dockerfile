# Use python runtime
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir .

# Create the missing config directory manually
RUN mkdir -p /root/.config/calcure

# Run the app
CMD ["python", "-m", "calcure"]