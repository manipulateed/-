from flask import Flask, request, jsonify
from models.MongoDBMgr import MongoDBMgr
from models.Sour_Record_Helper import Sour_Record_Helper
from models.Sour_Record import Sour_Record

app = Flask(__name__)

mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, mongo_uri)
sr_helper = Sour_Record_Helper(mongo_mgr)

@app.route('/Sour_Record_Controller/get_all', methods=['GET'])
def get_all_sour_records_by_user_id():
    """取得所有痠痛紀錄"""
    data = request.json
    if data:
        user_id = data.get('user_id')
        return_data = sr_helper.get_All_Sour_Record_by_UserId(user_id)
        return jsonify(success=True, user_id=user_id, response=return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@app.route('/Sour_Record_Controller/get', methods=['GET'])
def get_sour_record_by_id():
    """取得單一痠痛紀錄"""
    data = request.json
    if data:
        sour_record_id = data.get('sour_record_id')
        return_data = sr_helper.get_Sour_Record_by_Id(sour_record_id)
        return jsonify(success=True, sour_record_id = sour_record_id, response = return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400
    
@app.route('/Sour_Record_Controller/get_videos', methods=['GET'])
def get_videos_by_sour_record_id():
    """取得指定痠痛紀錄的推薦影片"""
    data = request.json
    if data:
        sour_record_id = data.get('sour_record_id')
        if sour_record_id:
            videos = sr_helper.get_Videos_by_Sour_Record_Id(sour_record_id)
            if videos:
                return jsonify(success=True, sour_record_id=sour_record_id, response=videos), 200
            else:
                return jsonify(success=False, message="No videos found for the given sour record ID"), 404
        else:
            return jsonify(success=False, message="Missing sour_record_id"), 400
    else:
        return jsonify(success=False, message="No data received"), 400


@app.route('/Sour_Record_Controller/create', methods=['POST'])
def create_sour_record():
    """建立新痠痛紀錄"""
    data = request.json
    if data:
        user_id = data.get('user_id')
        title = data.get('title')
        reason = data.get('reason')
        time = data.get('time')
        videos = data.get('videos', [])
        sr = Sour_Record("", user_id, title, reason, time, videos)
        if user_id and title and reason and time:
            sr_helper.create_sour_record(sr)
            return jsonify(success=True, user_id=user_id, title=title), 200
        else:
            return jsonify(success=False, message="Missing required fields"), 400
    else:
        return jsonify(success=False, message="No data received"), 400

@app.route('/Sour_Record_Controller/update', methods=['PUT'])
def update_sour_record_data():
    """修改痠痛紀錄"""
    data = request.json
    if data:
        sour_record_id = data.get('sour_record_id')
        field_name = data.get('field_name')
        new_value = data.get('new_value')
        return_data = sr_helper.update_sour_record(sour_record_id, field_name, new_value)
        return jsonify(success=True, response=return_data), 200
    else:
        return jsonify(success=False, message="No data received"), 400

@app.route('/Sour_Record_Controller/delete', methods=['DELETE'])
def delete_sour_record():
    """刪除痠痛紀錄"""
    data = request.json
    if data:
        sour_record_id = data.get('sour_record_id')
        sr_helper.delete_sour_record(sour_record_id)
        return jsonify(success=True, sour_record_id=sour_record_id), 200
    else:
        return jsonify(success=False, message="No data received"), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
