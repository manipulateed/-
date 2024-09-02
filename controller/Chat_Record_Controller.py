from flask import Flask, request, jsonify, Blueprint
from flask_jwt_extended import jwt_required, get_jwt_identity
from models.MongoDBMgr import MongoDBMgr
from models.Chat_Record_Helper import Chat_Record_Helper
from models.Chat_Record import Chat_Record
from models.Message import Message
from bson import ObjectId
from datetime import datetime

Chat_Record_bp = Blueprint('Chat_Record', __name__)

from dotenv import load_dotenv
import os
# 在應用啟動時加載 .env 文件
load_dotenv() 
mongo_uri = os.getenv('MONGODB_URI')
db_name = os.getenv('MONGODB_DATABASE')
mongo_mgr = MongoDBMgr(db_name, mongo_uri)
cr_helper = Chat_Record_Helper(mongo_mgr)

@Chat_Record_bp.route('/Chat_Record_Controller/get_chat_records', methods=['GET'])
@jwt_required()
def get_chat_records_by_user_id():
    """獲取用戶的所有聊天記錄"""

    # 從請求的標頭中提取 Authorization 標頭，並打印 token
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split()[1]  # Authorization: Bearer <token>
        print(f"JWT Token: {token}")  # 打印獲得的 JWT token
    
    current_user_id = get_jwt_identity()
    print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
    data = current_user_id
    
    if data:
        return_data = cr_helper.get_all_chat_records_by_user_id(data)
        return jsonify(success=True, user_id=data, response=return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@Chat_Record_bp.route('/Chat_Record_Controller/create_chat_record', methods=['POST'])
@jwt_required()
def create_chat_record():
    """創建新的聊天記錄"""
    data = request.json
    if data:
        id = ""

        # 從請求的標頭中提取 Authorization 標頭，並打印 token
        auth_header = request.headers.get('Authorization')
        if auth_header:
            token = auth_header.split()[1]  # Authorization: Bearer <token>
            print(f"JWT Token: {token}")  # 打印獲得的 JWT token
        
        current_user_id = get_jwt_identity()
        print(f"JWT Identity (current_user_id): {current_user_id}")  # 打印取得的 current_user_id
        user_id = current_user_id

        message = data.get('message')
        name = data.get('name')

        # 處理 Suggested_videos
        suggested_videos = data.get('suggested_videos', [])

        # 確保 suggested_videos 是一個列表
        if not isinstance(suggested_videos, list):
            suggested_videos = [suggested_videos]
        
        timestamp = datetime.now().isoformat()
        finished = data.get('finished')
        
        chat_record = Chat_Record(id, user_id, name, message, suggested_videos, timestamp, finished)

        #新增至資料庫
        result = cr_helper.save_to_db(chat_record)

        #取得Chat Record id
        chat_record.id = result['id']

        return jsonify(success=True, response=chat_record.get_chat_record_data()), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@Chat_Record_bp.route('/Chat_Record_Controller/update_chat_record', methods=['PUT'])
def update_chat_record():
    """更新現有的聊天記錄"""
    data = request.json
    if data:
        id = data.get('id')  # 假設你用record_id來查找要更新的記錄

        user_id = data.get('user_id')

        # 處理 messages
        messages = []
        for item in data.get('message'):
            character = item.get('character')
            content = item.get('content')
            date = item.get('date')
            time = item.get('time')
            
            message = Message(character, content, date, time)
            messages.append(message)
        message = [msg.get_Message_data() for msg in messages]

        formatted_messages = []
        for mes in message:
            formatted_message = {
                'Role': mes['character'],
                'Content': mes['content'],
                'Date': mes['date'],
                'Time': mes['time']
            }
            # 如果 Date 或 Time 是 datetime 對象，進行格式化
            if isinstance(formatted_message['Date'], datetime):
                formatted_message['Date'] = formatted_message['Date'].strftime("%Y-%m-%d")
            if isinstance(formatted_message['Time'], datetime):
                formatted_message['Time'] = formatted_message['Time'].strftime("%H:%M:%S")
            formatted_messages.append(formatted_message)

        name = data.get('name')

        # 處理 Suggested_videos
        suggested_videos = data.get('suggested_videos', [])
        if suggested_videos:
            # 確保 suggested_videos 是一個列表
            if not isinstance(suggested_videos, list):
                suggested_videos = [suggested_videos]
            
            # 格式化 suggested_videos
            formatted_suggested_videos = []
            for video in suggested_videos:
                video_ids = [ObjectId(str(vid['id'])) for vid in video.get('Video_id', [])]
                formatted_video = {
                    "Keyword": video.get('Keyword'),
                    "Video_id": video_ids
                }
                # 確保 Video_id 是一個列表
                if not isinstance(formatted_video["Video_id"], list):
                    formatted_video["Video_id"] = [formatted_video["Video_id"]]
                formatted_suggested_videos.append(formatted_video)

            suggested_videos = formatted_suggested_videos

        videos = []
        for video in data.get('suggested_videos'):
            keyword = video.get('Keyword', '')
            video_ids = [str(vid['id']) for vid in video.get('Video_id', [])]  # 將 ObjectId 轉成字串
            videos.append({
                "Keyword": keyword,
                "Video_id": video_ids
            })


        # 更新最後更新的時間戳
        timestamp = datetime.now().isoformat()

        finished = data.get('finished')

        chat_record = Chat_Record(id, user_id, name, message, suggested_videos, timestamp, finished)

        # 保存更新後的記錄
        result = cr_helper.update_message(chat_record)

        #如果更新成功
        if (result['success']):
           chat_record.message = formatted_messages
           chat_record.suggested_videos = videos
           return jsonify(success=True, response=chat_record.get_chat_record_data()), 200
        else:
            print(result['message'])
            return jsonify(success=False, message="No data received"), 500 
    else:
        return jsonify(success=False, message="No data received"), 400    

@Chat_Record_bp.route('/Chat_Record_Controller/delete_chat_record', methods=['DELETE'])
def delete_chat_record():
    """更新現有的聊天記錄"""
    data = request.args.get("id")
    if data:

        # 保存更新後的記錄
        result = cr_helper.remove_CR(data)

        #如果刪除成功
        if (result['success']):
           
           return jsonify(success=True, response=result['message']), 200
        else:
            return jsonify(success=False, response=result['message']), 500 
    else:
        return jsonify(success=False, message="No data received"), 400    

#甲資料
        # user_id = data
        # message1 = Message("user","123456","12.31","12.45")
        # message2 = Message("ai","654321","12.31","12.45")
        # message = [message1.get_Message_data(), message2.get_Message_data()]

        # suggested_videos = [{"伸展":[1,2,3]},{"姿勢":[6,9,8]}]       
        # formatted_suggested_videos = []
        # for video in suggested_videos:
        #     key = list(video.keys())[0]
        #     formatted_video = {
        #         "Keyword": key,
        #         "Video_id": video[key]
        #     }
        #     formatted_suggested_videos.append(formatted_video)

        # record1 = Chat_Record("1", 20, "大腿痠痛", message, formatted_suggested_videos, "12:23:56", "yes")
        # record2 = Chat_Record("2", 20, "小腿痠痛", message, formatted_suggested_videos, "12:23:56", "yes")

        # return_data = [record1.get_chat_record_data(), record2.get_chat_record_data()]