from flask import Flask, request, jsonify, blueprints
import sys
from controller.Collect_List_Controller import Collect_List_bp
from controller.Chat_Record_Controller import Chat_Record_bp
from controller.VideoController import Video_bp
from controller.UserController import user_bp
from controller.Call_GPT import callGPT_bp
from controller.Sour_Record_Controller import Sour_Record_bp
from flask_jwt_extended import JWTManager
from datetime import timedelta
from dotenv import load_dotenv
import os

#註冊控制器
app = Flask(__name__)
app.register_blueprint(Collect_List_bp, url_prefix='')
app.register_blueprint(user_bp, url_prefix='/user')
app.register_blueprint(Chat_Record_bp, url_prefix='')
app.register_blueprint(callGPT_bp, url_prefix='')
app.register_blueprint(Video_bp, url_prefix='')
app.register_blueprint(Sour_Record_bp, url_prefix='')

load_dotenv()  # 讀取 .env 文件中的變數
#設定JWT參數
app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=5)  # Token expiration time
jwt = JWTManager(app)

#測試用
@app.route('/login', methods=['POST'])
def receive_data():
    data = request.json #取得request到的json檔
    if data:
        print(f"Received data: {data}")
    else:
        print("No data received")
    return jsonify(success=True, received=data), 200

if __name__ == '__main__': 
    app.run(host='0.0.0.0', port=8080)
