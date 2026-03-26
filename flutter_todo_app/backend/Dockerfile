FROM python:3.11-slim

WORKDIR /app
COPY  requirement.txt .
RUN pip install --no-cache-dir --upgrade -r requirement.txt

COPY . .
CMD ["python","-m","uvicorn","main:app","--host","0.0.0.0","--port","8000"]
