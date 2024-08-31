from flask import Flask, request, jsonify, Blueprint
import sys
from models.MongoDBMgr import MongoDBMgr 
from models.Video import Video
from models.Video_Helper import Video_Helper

Video_bp = Blueprint('Video', __name__)

from dotenv import load_dotenv
import os
# 在應用啟動時加載 .env 文件
load_dotenv() 
mongo_uri = os.getenv('MONGODB_URI')
db_name = os.getenv('MONGODB_DATABASE')
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
vd_helper = Video_Helper(mongo_mgr)

@Video_bp.route('/api/video/create', methods = ['POST'])
def create_Video(): #-> check 是否已經存在資料庫裡了
    data = request.json
    if not data or 'url' not in data or 'title' not in data:
        return jsonify({"success": False, "message": "缺少必要的影片資訊"}), 400
    
    new_video = Video(name=data['name'], url=data['url'])
    result = vd_helper.create_video(new_video)
    if result['success']:
        return jsonify(result), 201  # 201 Created
    else:
        return jsonify(result), 409  # 409 Conflict

@Video_bp.route('/VideoController/get', methods = ['GET'])
def get_Video_by_VideoId():
    video_id = request.args.get('video_id')
    if video_id:
        vd_data = vd_helper.get_Video_Data_by_VideoID(video_id)
        return jsonify(status = '200', success = True, video_id = video_id, response = vd_data)
    else:
        return jsonify(status = '400', success = False, messsage = 'No data received')
    
@Video_bp.route('/api/video/search_and_create', methods=['POST'])
def search_and_create_videos(data):

    if not data or 'keyword' not in str(data):
        return {"success": False, "message": "缺少搜索關鍵詞"}
    
    keyword = data['keyword']
    max_results = data.get('max_results', 5)
    
    result = vd_helper.search_and_Create_Videos(keyword, max_results)
    
    if result['output_videos']:
        print("Done search Videos")
        return {
            "success": True, 
            "created_videos": result['created_videos'],
            "all_videos": result['output_videos']
        }
    else:
        return {"success": False, "message": "未找到任何視頻"}
 
