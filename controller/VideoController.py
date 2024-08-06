from flask import Flask, request, jsonify, Blueprint
# from models.MongoDBMgr import MongoDBMgr 
# from models.Video import Video
# from models.Video_Helper import Video_Helper

Video_bp = Blueprint('Video', __name__)
# app = Flask(__name__)

# mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
# db_name = "酸通"
# mongo_mgr = MongoDBMgr(db_name,mongo_uri)
# vd_helper = Video_Helper(mongo_mgr)

# @app.route('/api/video/create', methods = ['POST'])
# def create_Video(): #-> check 是否已經存在資料庫裡了
#     data = request.json
#     if not data or 'url' not in data or 'title' not in data:
#         return jsonify({"success": False, "message": "缺少必要的影片資訊"}), 400
    
#     new_video = Video(name=data['name'], url=data['url'])
#     result = vd_helper.create_video(new_video)
#     if result['success']:
#         return jsonify(result), 201  # 201 Created
#     else:
#         return jsonify(result), 409  # 409 Conflict

@Video_bp.route('/VideoController/get', methods = ['GET'])
def get_Video_by_VideoId():
    video_id = request.args.get('video_id')
    # if data:
    #     video_id = data.get('video_id')
    #     vd_data = vd_helper.get_Video_Data_by_VideoID(video_id)
    #     return jsonify(status = '200', success = True, video_id = video_id, response = vd_data)
    # else:
    #     return jsonify(status = '400', success = False, messsage = 'No data received')
    if video_id: 
        #return_data = vd_helper.get_Video_Data_by_VideoID(video_id)
        return_data = [{
            "id": str(10),
            "title": str(23),
            "description": "jimmy",
            "url": str(256)
        },{
            "id": str(20),
            "title": str(24),
            "description": "jimmyke",
            "url": str(5689)
        }]
        return jsonify(success=True, video_id = video_id , response = return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400
# @app.route('/api/video/search_and_create', methods=['POST'])
# def search_and_create_videos():
#     data = request.json
#     if not data or 'keyword' not in data:
#         return jsonify({"success": False, "message": "缺少搜索關鍵詞"}), 400
    
#     keyword = data['keyword']
#     max_results = data.get('max_results', 5)
    
#     result = vd_helper.search_and_Create_Videos(keyword, max_results)
    
#     if result['output_videos']:
#         return jsonify({
#             "success": True, 
#             "created_videos": result['created_videos'],
#             "all_videos": result['output_videos']
#         }), 200
#     else:
#         return jsonify({"success": False, "message": "未找到任何視頻"}), 404
 
# if __name__ == '__main__':
#     app.run(debug=True)