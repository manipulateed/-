from flask import Flask, request, jsonify, Blueprint
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from models.MongoDBMgr import MongoDBMgr 
from models.User_Helper import UserHelper
from models.User import User
from bson import ObjectId

user_bp = Blueprint('user_bp',__name__)

from dotenv import load_dotenv
import os
# 在應用啟動時加載 .env 文件
load_dotenv() 
mongo_uri = os.getenv('MONGODB_URI')
db_name = os.getenv('MONGODB_DATABASE')
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
user_helper = UserHelper(mongo_mgr)

@user_bp.route('/user/create_user', methods=['POST'])
def create_user():
    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    icon = data.get('icon', "1")  # 默認值為 "1"

    if not all([name, email, password]):
        response = jsonify(status = '400', success=False, message='Missing required fields')
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response

    user = User(name=name, email=email, password=password, icon = icon)
    result = user_helper.create_user(user)

    if result['success'] :
        response = jsonify(status='200', success=True, message='User created successfully', response=result)
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response
    else:
        response = jsonify(status='400', success=False, message='Failed to create user', response=result)
        print(f"Sending response: {response.get_data(as_text=True)}")  # 印response
        return response

@user_bp.route('/user/login', methods=['POST'])
def login():
    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據

    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify(status='300', success=False, message='Email and password are required'), 400

    user = user_helper.get_user_by_email_and_password(email, password)
    if user['success']:
        access_token = create_access_token(identity=str(user['id'])) #創造token
        print(f"Created access_token: {access_token}")  # 打印創建的 access_token
        return jsonify(status='200', success=True, message='Login successful', access_token=access_token), 200
    else:
        return jsonify(status='400', success=False, message='Invalid email or password'), 401

@user_bp.route('/user/get_user_byUserID', methods=['GET'])
@jwt_required()
def get_user_byUserID():
    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id

    user = user_helper.get_user_by_id(current_user_id)
    
    if user['success']:
        user_data = {
            'id': str(user['id']),
            'name': user['name'],
            'email': user['email'],
            'password': user['password'],
            'icon': user.get('icon','1')# 添加 icon 欄位，如果不存在則默認為 "1"
        }
        return jsonify(status='200', success=True, message='User data retrieved successfully', response=[user_data]), 200
    else:
        return jsonify(status='400', success=False, message='User not found'), 404

@user_bp.route('/user/update_user', methods=['PUT'])
def update_user():
    user_id = request.args.get('user_id')
    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
    
    if not user_id:
        return jsonify(success=False, message='缺少必要的參數(user_id)'), 300

    data = request.get_json()
    print(f"Received data: {data}")  # 添加這行來打印接收到的數據
    if not data:
        return jsonify(success=False, message='未提供有效的JSON數據'), 400

    field_name = data.get('field')
    new_value = data.get('new_value')

    if not field_name or new_value is None:
        return jsonify(success=False, message='欄位名稱和新值不能為空'), 400

    # 驗證用戶身份
    user_result = user_helper.get_user_by_id(user_id)
    if not user_result['success']:
        return jsonify(success=False, message=user_result['message']), 404

    if field_name == 'name':
        result = user_helper.update_user_field(user_id, 'Name', new_value)
    elif field_name == 'password':
        result = user_helper.update_user_field(user_id, 'Password', new_value)
    elif field_name == 'email':
        result = user_helper.update_user_field(user_id, 'Email', new_value)
    elif field_name == 'icon':
        result = user_helper.update_user_field(user_id, 'Icon', new_value)
    else:
        return jsonify(success=False, message='不支持的欄位名稱'), 400

    if result['success']:
        return jsonify(success=True, message='更改資料成功!'), 200
    else:
        return jsonify(success=False, message=result['message']), 400

if __name__ == '__main__':
    user_bp.run(debug=True)
    
#沒有delete user
@user_bp.route('/user/delete_user', methods=['DELETE'])
def delete_user():
    user_id = request.args.get('user_id')
    user_collection = user_helper.get_collection('User')
    result = user_collection.delete_one({"_id": ObjectId(user_id)})

    if result.deleted_count > 0:
        return jsonify(status = '200', success=True, message='用戶刪除成功')
    else:
        return jsonify(status = '400', success=False, message='找不到用戶')

