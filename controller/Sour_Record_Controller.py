from flask import Flask, request, jsonify, Blueprint
import sys
sys.path.append(r'..')

from models.MongoDBMgr import MongoDBMgr
from models.Sour_Record_Helper import Sour_Record_Helper
from models.Sour_Record import Sour_Record


Sour_Record_bp = Blueprint ('Sour_Record', __name__)

app = Flask(__name__)


mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name, mongo_uri)
sr_helper = Sour_Record_Helper(mongo_mgr)



@Sour_Record_bp.route('/Sour_Record_Controller/get_ALLSR', methods=['GET'])
def get_all_sour_records_by_user_id():
    """取得所有痠痛紀錄"""
    user_id = request.args.get('user_id')
    #user_id=ObjectId(user_id)
    if user_id:
        return_data = sr_helper.get_All_Sour_Record_by_UserId(user_id)
        print(return_data);   
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
def create_sour_record():
    """建立新痠痛紀錄"""

    user_id = request.args.get('user_id')

    data = request.get_json()     
    reason = data.get('reason')
    time =data.get('time')

    new_Sour_Record = Sour_Record(id="1", user_id=user_id, reason=reason, time=time, videos=[])
    sr_helper.create_sour_record(new_Sour_Record)

    if data:
        print(user_id, reason, time)
        return jsonify(success=True, message = "成功"),200    
    else:
        print("failed")
        return jsonify(success=False, message = "No data received"),400    


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

        print(id, new_value, field_name, result)
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

    

'''
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

'''
