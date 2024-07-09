from flask import Flask, request, jsonify
from models.MongoDBMgr import MongoDBMgr 
from models.Chat_Record_Helper import Chat_Record_Helper  
from models.Collect_List import Collect_List

app = Flask(__name__)

mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
cl_helper = Chat_Record_Helper(mongo_mgr)

@app.route('/Collect_List_Controller/get_CL', methods=['GET'])
def get_All_CL_by_UserId():
    """取得所有收藏清單"""
    data = request.json
    if data:
        user_id = data.get('user_id')
        cl_helper.get_All_CL_by_UserId(user_id)
        return jsonify(success=True, user_id=user_id), 200
    else:
        return jsonify(success=False, message="No data received"), 400

def get_CL_by_UserId_and_Name():
    """取得單一收藏清單"""
    data = request.json
    if data:
        user_id = data.get('user_id')
        name = data.get('name')
        cl_helper.get_CL_by_UserId_and_Name(user_id,name)
        return jsonify(success=True, user_id=user_id, name=name), 200
    else:
        return jsonify(success=False, message="No data received"), 400


@app.route('/Collect_List_Controller/create_CL', methods=['POST'])
def create_CL_by_UserId():
    """建立新收藏清單"""
    data = request.json
    if data:
        user_id = data.get('user_id')
        name = data.get('name')
        cl = Collect_List("",user_id,name,"")
        if user_id and name:
            cl_helper.create_CL_by_UserId(cl)
            return jsonify(success=True, user_id=user_id, name=name), 200
        else:
            return jsonify(success=False, message="Missing user_id or CL_name"), 400
    else:
        return jsonify(success=False, message="No data received"), 400
    
@app.route('/Collect_List_Controller/update_CL', methods=['PUT'])
def update_CL_data():
    """修改收藏清單"""
    data = request.json
    if data:
        cl_id = data.get('cl_id')
        type = data.get('type')
        new_value = data.get('new_value')
        cl_helper.update_CL_data(cl_id,type,new_value)
    else:
        return jsonify(success=False, message="No data received"), 400

@app.route('/Collect_List_Controller/remove_CL', methods=['DELETE'])
def remove_CL():
    """刪除收藏清單"""
    data = request.json
    if data:
        cl_id = data.get('cl_id')
        cl_helper.remove_CL(cl_id)
        return jsonify(success=True, cl_id=cl_id), 200
    else:
        return jsonify(success=False, message="No data received"), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)