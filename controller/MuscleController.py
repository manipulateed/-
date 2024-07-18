from flask import Flask, request, jsonify
from models.MongoDBMgr import MongoDBMgr
from models.Muscle_Helper import Muscle_Helper
from models.Muscle import Muscle

app = Flask(__name__)

mongo_uri = "mongodb+srv://evan:evan1204@sourpass88.rsb5qbq.mongodb.net/"
db_name = "酸通"
mongo_mgr = MongoDBMgr(db_name,mongo_uri)
ms_helper = Muscle_Helper(mongo_mgr)

@app.route('/MuscleContorller/get', methods=['GET'])
def get_muscle_by_muscle_id():
    """取得單一症狀資訊"""
    data = request.json
    if data:
        muscle_id = data.get('muscle_id')
        ms_data = ms_helper.get_Muscle_by_Muscle_Id(muscle_id)
        return jsonify(status = '200', success = True, muscle_id = muscle_id, response = ms_data)
    else:
        return jsonify(status = '400', success = False, messsage = 'No data received')

def get_muscleNameList_by_category():
    """取得各部位之各種病症"""
    data = request.json
    if data:
        category = data.get('category')
        muscleNameList = ms_helper.get_MuscleNameList_by_Category(category)
        return jsonify(status = '200', success = True, category=category, response=muscleNameList)
    else:
        return jsonify(status = '400', success = False, messsage = 'No data received')

if __name__ == '__main__':
    app.run(debug=True)