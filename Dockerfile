# 使用 Python 3.9.7 基礎映像檔
FROM python:3.9.7-slim

# 設定工作目錄
WORKDIR /app

# 複製需求檔案並安裝 Python 套件
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# 複製所有應用程式檔案到容器
COPY . .

# 開放應用程式運行的 port
EXPOSE 8080

# 設定 Flask 的環境變數
ENV FLASK_APP=main.py
ENV FLASK_ENV=production

# 執行 Flask 應用程式
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
