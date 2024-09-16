from flask import Flask, request, jsonify, Blueprint
from flask_jwt_extended import jwt_required, get_jwt_identity
from bson import ObjectId
from models.MongoDBMgr import MongoDBMgr
from models.Sour_Record_Helper import Sour_Record_Helper
from models.Sour_Record import Sour_Record

Sour_Record_bp = Blueprint ('Sour_Record', __name__)

from dotenv import load_dotenv
import os
# 在應用啟動時加載 .env 文件
load_dotenv() 
mongo_uri = os.getenv('MONGODB_URI')
db_name = os.getenv('MONGODB_DATABASE')
mongo_mgr = MongoDBMgr(db_name, mongo_uri)
sr_helper = Sour_Record_Helper(mongo_mgr)

@Sour_Record_bp.route('/Sour_Record_Controller/get_ALLSR', methods=['GET'])
@jwt_required()
def get_all_sour_records_by_user_id():
    """取得所有痠痛紀錄"""

    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
    user_id = current_user_id

    if user_id:
        return_data = sr_helper.get_All_Sour_Record_by_UserId(user_id) 
        return jsonify(success=True, user_id=user_id, response=return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400



@Sour_Record_bp.route('/Sour_Record_Controller/get', methods=['GET'])
def get_sour_record_by_id():
    #取得單一痠痛紀錄
    id = request.args.get('id')
    if id:
        result = sr_helper.get_Sour_Record_by_Id(id) 
        return jsonify(success=True, response=result),200
    else:
        return jsonify(success=False, message = "No data received"),400    


@Sour_Record_bp.route('/Sour_Record_Controller/create', methods=['POST'])
@jwt_required()
def create_sour_record():
    """建立新痠痛紀錄"""
    
    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
    user_id = current_user_id
    
    data = request.get_json()     
    reason = data.get('reason')
    time = data.get('time')

    videos = data.get('videos')
    if videos:
        # 確保 videos 是一個列表_id = 
        if not isinstance(videos, list):
            videos = [videos]
        
        # 格式化 videos
        formatted_videos = []
        for video in videos:
            video_ids = [ObjectId(str(vid)) for vid in video.get('Video_id', [])]
            formatted_video = {
                "Keyword": video.get('Keyword'),
                "Video_id": video_ids
            }
            # 確保 Video_id 是一個列表
            if not isinstance(formatted_video["Video_id"], list):
                formatted_video["Video_id"] = [formatted_video["Video_id"]]
            formatted_videos.append(formatted_video)

        videos = formatted_videos

    new_Sour_Record = Sour_Record(id="1", user_id=user_id, reason=reason, time=time, videos=videos)
    sr_helper.create_sour_record(new_Sour_Record)

    if data:
        return {"success": True, "message": "新增成功"}    
    else:
        print("failed")
        return {"success": False, "message": "新增失敗"}    


@Sour_Record_bp.route('/Sour_Record_Controller/update', methods=['PUT'])
def update_sour_record_data():
    """修改痠痛紀錄"""
    id = request.args.get('id')
    data = request.get_json() 
    record_id = data.get('id')       
    new_value = data.get('new_value')
    field_name =data.get('field_name')

    if id:
        result=sr_helper.update_sour_record(id, field_name, new_value)

        return jsonify(success=True, message = "成功"),200    
    else:
        print("failed")
        return jsonify(success=False, message = "No data received"),400    


@Sour_Record_bp.route('/Sour_Record_Controller/delete', methods=['DELETE'])
def delete_sour_record():
    """刪除痠痛紀錄"""
    id = request.args.get('id')
    if id:
         result=sr_helper.delete_sour_record(id)
         return jsonify(success=True, sour_record_id=id), 200
    else:
        return jsonify(success=False, message="No data received"), 400