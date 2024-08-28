from flask import Flask, request, jsonify, Blueprint
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.MongoDBMgr import MongoDBMgr 
from models.Collect_List_Helper import Collect_List_Helper  
from models.Collect_List import Collect_List

Collect_List_bp = Blueprint('Collect_List', __name__)

from dotenv import load_dotenv
import os
# 在應用啟動時加載 .env 文件
load_dotenv() 
mongo_uri = os.getenv('MONGODB_URI')
db_name = os.getenv('MONGODB_DATABASE')
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
cl_helper = Collect_List_Helper(mongo_mgr)

@Collect_List_bp.route('/Collect_List_Controller/get_ALLCL', methods=['GET'])
def get_All_CL_by_UserId():
    """取得所有收藏清單"""

    user_id = request.args.get('user_id')
    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id

    if user_id: 
        return_data = cl_helper.get_All_CL_by_UserId(user_id)
        return jsonify(success=True, user_id=user_id , response = return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@Collect_List_bp.route('/Collect_List_Controller/get_CL', methods=['GET'])
def get_CL_by_UserId_and_ClId():
    """取得單一收藏清單"""
    # data = request.get_json()
    user_id = request.args.get('user_id')
    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id

    cl_id = request.args.get('ClId')
    if user_id and cl_id:
        # user_id = data.get('user_id')
        # cl_id = data.get('cl_id')
        return_data = cl_helper.get_CL_by_UserId_and_ClId(user_id,cl_id)
        return jsonify(success=True, response = return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400


@Collect_List_bp.route('/Collect_List_Controller/create_CL', methods=['POST'])
def create_CL_by_UserId():
    """建立新收藏清單"""
    try:
        data = request.get_json()
        print("Received data:", data)  # 添加這一行來打印接收到的數據
        user_id = data.get('user_id')
        # 從請求的標頭中提取 Authorization 標頭，並打印 token
        auth_header = request.headers.get('Authorization')
        if auth_header:
            token = auth_header.split()[1]  # Authorization: Bearer <token>
            print(f"JWT Token: {token}")  # 打印獲得的 JWT token
        
        current_user_id = get_jwt_identity()
        print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id

        name = data.get('name')
        
        if user_id and name:
            cl = Collect_List("", user_id, name, "")
            cl_helper.create_CL_by_UserId(cl)
            return jsonify(success=True, user_id=user_id, name=name), 200
        else:
            return jsonify(success=False, message="Missing user_id or CL_name"), 400
    except Exception as e:
        print("Error:", e)  # 添加這一行來打印錯誤信息
        return jsonify(success=False, message=str(e)), 400
    
@Collect_List_bp.route('/Collect_List_Controller/update_CL', methods=['PUT'])
def update_CL_data():
    """修改收藏清單"""
    data = request.json
    cl_id = data.get('cl_id')
    type = data.get('type')
    new_value = data.get('new_value')
    if cl_id and type and new_value:
        return_data = cl_helper.update_CL_data(cl_id,type,new_value)
        return jsonify(success=True, response = return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@Collect_List_bp.route('/Collect_List_Controller/remove_CL', methods=['DELETE'])
def remove_CL():
    """刪除收藏清單"""
    data = request.get_json()
    cl_id = data.get('cl_id')
    if cl_id:
        cl_helper.remove_CL(cl_id)
        return jsonify(success=True, cl_id=cl_id), 200
    else:
        return jsonify(success=False, message="No data received"), 400
