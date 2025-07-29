FROM python:3.11-slim

# Avoid Python bytecode & buffer issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    poppler-utils \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1 \                     # <--- ✅ This fixes libGL.so.1 error
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY . .

# Expose port for Streamlit
EXPOSE 8501

# Run your app
CMD ["streamlit", "run", "frontend/display.py", "--server.port=8501", "--server.address=0.0.0.0"]
