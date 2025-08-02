# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set a working directory inside the container
WORKDIR /app

# Copy requirements.txt (if you have it) and install dependencies
# If you don't have a requirements.txt, you can install Flask directly
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app files
COPY . .

# Expose port 5000 (Flask's default port)
EXPOSE 5000

# Run the Flask app when the container starts
CMD ["python", "flask-app.py"]
