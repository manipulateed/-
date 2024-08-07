from flask import Flask, request, jsonify, Blueprint
import sys
sys.path.append(r'..')
#from models.MongoDBMgr import MongoDBMgr
from models.Chat_Record_Helper import Chat_Record_Helper
from models.Chat_Record import Chat_Record
from models.Message import Message
from bson import ObjectId
from datetime import datetime
import sys
sys.path.append(r'..')
Chat_Record_bp = Blueprint('Chat_Record', __name__)

mongo_uri = "mongodb+srv://username:password@your-cluster.mongodb.net/"
db_name = "your_database_name"
#mongo_mgr = MongoDBMgr(db_name, mongo_uri)
#cr_helper = Chat_Record_Helper(mongo_mgr)

@Chat_Record_bp.route('/Chat_Record_Controller/get_chat_records', methods=['GET'])
def get_chat_records_by_user_id():
    """獲取用戶的所有聊天記錄"""
    data = request.args.get("user_id")
    if data:
        user_id = data
        message1 = Message("user","123456","12.31","12.45")
        message2 = Message("ai","654321","12.31","12.45")
        message = [message1.get_Message_data(), message2.get_Message_data()]

        suggested_videos = [{"伸展":[1,2,3]},{"姿勢":[6,9,8]}]       
        formatted_suggested_videos = []
        for video in suggested_videos:
            key = list(video.keys())[0]
            formatted_video = {
                "Keyword": key,
                "Video_id": video[key]
            }
            formatted_suggested_videos.append(formatted_video)

        record1 = Chat_Record("1", 20, "大腿痠痛", message, formatted_suggested_videos, "12:23:56", "yes")
        record2 = Chat_Record("2", 20, "小腿痠痛", message, formatted_suggested_videos, "12:23:56", "yes")

        return_data = [record1.get_chat_record_data(), record2.get_chat_record_data()]

        #return_data = cr_helper.get_all_chat_records_by_user_id(user_id)
        return jsonify(success=True, user_id=user_id, response=return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

# @Chat_Record_bp.route('/Chat_Record_Controller/get_chat_record', methods=['GET'])
# def get_chat_record_by_id():
#     """獲取單一聊天記錄"""
#     data = request.json
#     if data:
#         record_id = data.get('record_id')
#         return_data = cr_helper.get_Chat_Record_by_id(record_id)
#         return jsonify(success=True, response=return_data), 200
#     else:
#         return jsonify(success=False, message="No data received"), 400

@Chat_Record_bp.route('/Chat_Record_Controller/create_chat_record', methods=['POST'])
def create_chat_record():
    """創建新的聊天記錄"""
    data = request.json
    if data:
        id = ""
        user_id = data.get('user_id')
        message = data.get('message')

        name = data.get('name')
        timestamp = data.get('last_update_timestamp')

        # 處理 Suggested_videos
        suggested_videos = data.get('suggested_videos', [])
        # 確保 suggested_videos 是一個列表
        if not isinstance(suggested_videos, list):
            suggested_videos = [suggested_videos]
        
        # 格式化 suggested_videos
        formatted_suggested_videos = []
        for video in suggested_videos:
            formatted_video = {
                "Keyword": video.get('keyword'),
                "Video_id": video.get('video_id', [])
            }
            # 確保 Video_id 是一個列表
            if not isinstance(formatted_video["Video_id"], list):
                formatted_video["Video_id"] = [formatted_video["Video_id"]]
            formatted_suggested_videos.append(formatted_video)

        timestamp = datetime.now().isoformat()
        finished = data.get('finished')
        
        chat_record = Chat_Record(id, user_id, name, message, formatted_suggested_videos, timestamp, finished)
        #result = cr_helper.save_to_db(chat_record)
        print(chat_record.get_chat_record_data())
        return jsonify(success=True, response=chat_record.get_chat_record_data()), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@Chat_Record_bp.route('/Chat_Record_Controller/update_chat_record', methods=['PUT'])
def update_chat_record():
    """更新現有的聊天記錄"""
    data = request.json
    if data:
        id = data.get('id')  # 假設你用record_id來查找要更新的記錄

        # 查找現有的聊天記錄
        #chat_record = Chat_Record.query.filter_by(id=id).first()
        # 更新記錄的屬性
        user_id = data.get('user_id')
        message = data.get('message')
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
                formatted_video = {
                    "Keyword": video.get('keyword'),
                    "Video_id": video.get('video_id', [])
                }
                # 確保 Video_id 是一個列表
                if not isinstance(formatted_video["Video_id"], list):
                    formatted_video["Video_id"] = [formatted_video["Video_id"]]
                formatted_suggested_videos.append(formatted_video)

            suggested_videos = formatted_suggested_videos

        # 更新最後更新的時間戳
        timestamp = datetime.now().isoformat()

        finished = data.get('finished')

        chat_record = Chat_Record(id, user_id, name, message, formatted_suggested_videos, timestamp, finished)
        # 保存更新後的記錄
        # result = cr_helper.save_to_db(chat_record)
        print(chat_record.get_chat_record_data())
        return jsonify(success=True, response=chat_record.get_chat_record_data()), 200
    else:
        return jsonify(success=False, message="No data received"), 400    
'''
@app.route('/Chat_Record_Controller/update_chat_record', methods=['PUT'])
def update_chat_record():
    """更新現有的聊天記錄"""
    data = request.json
    if data:
        record_id = data.get('record_id')
        new_message = {
            "Role": data.get('role'),
            "Content": data.get('content'),
            "Date": datetime.now().strftime("%Y-%m-%d"),
            "Time": datetime.now().strftime("%H:%M")
        }
        result = cr_helper.update_message(record_id, new_message)
        return jsonify(success=True, response=result), 200
    else:
        return jsonify(success=False, message="No data received"), 400
'''

'''
@app.route('/Chat_Record_Controller/delete_chat_record', methods=['DELETE'])
def delete_chat_record():
    """刪除聊天記錄"""
    data = request.json
    if data:
        record_id = data.get('record_id')
        result = cr_helper.delete_chat_record(record_id)
        return jsonify(success=True, response=result), 200
    else:
        return jsonify(success=False, message="No data received"), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
'''