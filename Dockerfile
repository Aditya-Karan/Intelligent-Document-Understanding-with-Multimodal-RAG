# Start with a slim image
FROM python:3.11-slim

# Install system dependencies for unstructured, tesseract, OpenCV, etc.
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    tesseract-ocr \
    poppler-utils \
    libmagic1 \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the port your app runs on (adjust if needed)
EXPOSE 8501

# Start the Streamlit app
CMD ["streamlit", "run", "frontend/display.py"]
